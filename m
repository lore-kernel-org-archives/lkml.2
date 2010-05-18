Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757824Ab0ERVxM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 17:53:12 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:49651 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755619Ab0ERVxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 17:53:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH v3 00/10] BKL conversion in tty layer
Date: Tue, 18 May 2010 23:52:01 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
References: <1273957196-13768-1-git-send-email-arnd@arndb.de> <201005172030.23741.arnd@arndb.de> <20100518042752.GA20470@suse.de>
In-Reply-To: <20100518042752.GA20470@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005182352.01711.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/R1g2atiWRdBmdUUXgrofCqI0lkz3VRK4c16B
 1dzHHYfI/n/yMTkj5eyk2HkfLUvLknyVq65k99UuntgAMo4yC0
 q4xlfQm4SrWFdDnGx895Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 May 2010, Greg KH wrote:
> On Mon, May 17, 2010 at 08:30:23PM +0200, Arnd Bergmann wrote:
> > Ok, I'll make sure it still works with .35-rc1 when it's out and add
> > Alan's ACK, then send a you a pull request. Did you already merge the
> > series from Alan that this is based on, or do you want those patches
> > to wait as well? They are in my git tree, so they will be included
> > in my pull request if they are not in -rc1.
> 
> No, I do not have his patches anywhere, as I didn't expect that they
> were being sent to me to apply :)
> 
> > Also, it would be nice if you could merge the first patch of my
> > series, which should be completely harmless (it just renames
> > function calls) but having it upstream means that we can
> > keep the remaining patches that are required for BKL-less
> > kernels a lot smaller.
> 
> Can you resend this patch to me so that I can include it?

I think we should only merge this patch if you also want to
take the patches from Alan mentioned above, otherwise it would
cause more trouble to rebase everything than we can gain from
merging it now.

If this makes sense to you, please pull

git://git.kernel.org/pub/scm/linux/kernel/git/arnd/playground.git tty-for-2.6.35

This contains all of Alan's patches, plus the first one of my
series on top of that.

	Arnd
