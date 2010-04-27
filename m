Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab0D0UTF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 16:19:05 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:59530 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522Ab0D0UTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 16:19:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=aEW9viy/pEEufIGb4+sR1CNjejk6VG1TLaTKiX8PuK8wQxkHorWOGhzSDkeTLEFabk
         f/hNR0TmHBNJYX2SKmMUz1EuToxW9vqnpV5t41WnELERKXRoxCLCA0DNmxjAgPDKyxRT
         7WRE9Z6gMEY8s6R3R4TeUNU88y0XSlZF6U8Zo=
Date: Tue, 27 Apr 2010 22:12:52 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: John Kacur <jkacur@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
       Jan Blunck <jblunck@gmail.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/7] logfs: push down BKL into ioctl function
Message-ID: <20100427201247.GE5586@nowhere>
References: <alpine.LFD.2.00.1004271359180.3318@localhost> <alpine.LFD.2.00.1004271725490.3318@localhost> <20100427153209.GD16794@logfs.org> <201004271738.50505.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201004271738.50505.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 05:38:50PM +0200, Arnd Bergmann wrote:
> On Tuesday 27 April 2010, Jörn Engel wrote:
> > On Tue, 27 April 2010 17:27:19 +0200, John Kacur wrote:
> > > 
> > > Hasn't the "current" merge window been over with for weeks? I was assuming 
> > > that bkl push down, or other bkl patches are for the next merge window.
> > 
> > That's what I was thinking.  But some of the bkl related discussion gave
> > me the impression that such patches were still being merged.  So I
> > wanted to be sure.
> 
> Yes, just queue it for the 2.6.35-rc1 window and make sure it shows up in
> linux-next, or send a replacement patch with your Ack or S-o-b so we can
> put it into the BKL queue.
> 
> 	Arnd


I've applied this series in bkl/ioctl, it passed allyesconfig in sparc.
I will apply the others from you and John tomorrow or so (and will enjoy
my part as well). Jörn, please queue this patch if you want to, as you prefer,
we can host it as well if necessary.

Linus I hope you don't mind but I've dropped the .bkl_ioctl renaming.
In fact it had conflicts with several trees in Linux-next and now that
we are about to pushdown in every ioctl users, this would be an
unnecessary step I think.

Thanks.

