Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035Ab2G3DHX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 23:07:23 -0400
Received: from tundra.namei.org ([65.99.196.166]:57097 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753929Ab2G3DHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 23:07:22 -0400
Date: Mon, 30 Jul 2012 13:07:14 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Dave Jones <davej@redhat.com>
cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>, sds@tycho.nsa.gov,
        james.l.morris@oracle.com, eparis@parisplace.org
Subject: Re: selinux_inode_setxattr oops.
In-Reply-To: <20120725154739.GA28245@redhat.com>
Message-ID: <alpine.LRH.2.02.1207301306330.16928@tundra.namei.org>
References: <20120604215729.GA2531@redhat.com> <20120609071516.GZ30000@ZenIV.linux.org.uk> <20120725154739.GA28245@redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jul 2012, Dave Jones wrote:

> Did this get queued up anywhere ?
> I just stumbled across this still sitting in my tree. I've not seen the spew
> from fuzzing since adding it, so I guess I can add my Tested-by: there.

Thanks -- I don't know if it's in Eric's tree (he's away).


-- 
James Morris
<jmorris@namei.org>
