Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516Ab2ARArk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 19:47:40 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:45606 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756424Ab2ARAri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 19:47:38 -0500
Date: Wed, 18 Jan 2012 00:47:35 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [git pull] aush^H^Hdit queue
Message-ID: <20120118004735.GV23916@ZenIV.linux.org.uk>
References: <20120117213429.GS23916@ZenIV.linux.org.uk>
 <CA+55aFw_9Wm=qUH+39wb7Xq5KFTZZ4TqgkwMksrD_Q8G-uO3jg@mail.gmail.com>
 <20120118003840.GT23916@ZenIV.linux.org.uk>
 <20120118004518.GU23916@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120118004518.GU23916@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 12:45:18AM +0000, Al Viro wrote:
> Typo in init/Kconfig fixed, amended into the commit in question, the rest
> cherry-picked on top of the amended commit.
> 
> git://git.kernel.org:/pub/scm/linux/kernel/git/viro/audit.git for-linus2

Grrrrr...  OK, I really need to get some coffee and test the damn sed
script before using it.  _This_ time it was a bug in the script ;-/
