Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653Ab1JGU7F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 16:59:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55080 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754420Ab1JGU7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 16:59:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-pm tree back at kernel.org (Re: linux-next: temporary github repository)
Date: Fri, 7 Oct 2011 23:01:20 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc9+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
References: <20110918212535.a1038aa5f0caad9d83e351b2@canb.auug.org.au> <201109181518.35788.rjw@sisk.pl>
In-Reply-To: <201109181518.35788.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201110072301.21087.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Sunday, September 18, 2011, Rafael J. Wysocki wrote:
> Hi,
> 
> On Sunday, September 18, 2011, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Since kernel.org has not returned yet, I have created a temporary
> > repository on github that will contain linux-next until the kernel.org
> > servers return. You can access it at
> > git://github.com/sfrothwell/linux-next.git
> 
> OK, so the temporary location of the linux-pm tree's linux-next branch is at:
> 
> git://github.com/rjwysocki/linux-pm.git linux-next

The linux-pm tree is back at kernel.org, so please use:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git

from now on.  I'm still planning to keep the tree at github up to date, though.

Thanks,
Rafael
