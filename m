Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757044Ab1FUWk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 18:40:29 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35148 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756257Ab1FUWk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 18:40:28 -0400
Date: Tue, 21 Jun 2011 23:40:27 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Greg Dietsche <greg@gregd.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: 3.0 rc3 bug & warning fs/inode.c && fs/fs-writeback.c
Message-ID: <20110621224027.GA11521@ZenIV.linux.org.uk>
References: <4E008DD0.2090809@gregd.org>
 <20110621124556.GZ11521@ZenIV.linux.org.uk>
 <4E01195F.8040000@gregd.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E01195F.8040000@gregd.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 05:21:19PM -0500, Greg Dietsche wrote:

> I'm leaning towards might be something else. Correct me if I'm
> wrong, but it seems that 50338b889dc504c69e0cb316ac92d1b9e51f3c8a
> was included in rc3.

Nope - it's in a branch that started before -rc3 but got merged between
-rc3 and -rc4.  git log v3.0-rc3 fs/namei.c and watch it not being there
while the same with s/rc3/rc4/ will show it just fine.  In fact, the last
commit touching fs/namei.c in -rc3 is the one that introduced the breakage
fixed by 50338b889dc504c69e0cb316ac92d1b9e51f3c8a.
