Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759730Ab0HEGZg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 02:25:36 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:57056 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757668Ab0HEGZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 02:25:35 -0400
Date: Thu, 5 Aug 2010 08:24:32 +0200
From: Pavel Machek <pavel@ucw.cz>
To: James Morris <jmorris@namei.org>
Cc: John Johansen <john.johansen@canonical.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [AppArmor #7 0/13] AppArmor security module
Message-ID: <20100805062431.GA1546@ucw.cz>
References: <1280440089-3203-1-git-send-email-john.johansen@canonical.com>
 <alpine.LRH.2.00.1007300903440.7719@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1007300903440.7719@tundra.namei.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2010-07-30 09:05:23, James Morris wrote:
> On Thu, 29 Jul 2010, John Johansen wrote:
> 
> > This is the seveth general posting of the newest version of the
> > AppArmor security module it has been rewritten to use the security_path
> > hooks instead of the previous vfs approach.  The current implementation
> > is aimed at being as semantically close to previous versions of AppArmor
> > as possible while using the existing LSM infrastructure.
> 
> Applied to
> git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next
> 
> Please carry out any further development against the above tree.
> 
> Note that I added the patch below to update AA against the latest 
> version of path_truncate:

Ok, so now we have two name-based "security" modules. Can we at least
drop TOMOYO? That seems to have all apparmor disadvantages plus some
more...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
