Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757113Ab0F3TEF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 15:04:05 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60818 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754914Ab0F3TED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 15:04:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jtYwOXCxlsCr4fcWj+iNtyjWY7/zqVmgQ8dql3MOAeT7vsU2qebEJCv8ehMNOS2qUq
         HBNsRCOPerXKD/6S+JhUJDGbKLhoHnrRcXaRZjQHEYRPH+gC+po/eseIXhbd4Xo4DN0L
         hR8zavB8XhnDjq0qqsPlh7rA8ozxQcsMWxA9c=
Date: Wed, 30 Jun 2010 21:04:08 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Alexandre Julliard <julliard@winehq.org>,
       "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Prasad <prasad@linux.vnet.ibm.com>,
       "2 . 6 . 33 . x 2 . 6 . 34 . x" <stable@kernel.org>
Subject: Re: [GIT PULL] x86 breakpoint regression fix
Message-ID: <20100630190405.GB5243@nowhere>
References: <1277906559-10624-1-git-send-regression-fweisbec@gmail.com> <alpine.LFD.2.00.1006301535480.13070@eddie.linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1006301535480.13070@eddie.linux-mips.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 03:40:51PM +0100, Maciej W. Rozycki wrote:
> On Wed, 30 Jun 2010, Frederic Weisbecker wrote:
> 
> >     - icebp/int01 trap. This instruction (0xf1) is undocumented and
> >       generates an int 1 exception. Unlike single step through TF
> >       flag, it doesn't set the single step origin of the exception
> >       in dr6.
> 
>  Not quite completely undocumented, but a bit obscure indeed.  GDB calls 
> this instruction ICEBP and some Intel sources -- INT1.  It's been around 
> for a while (at least since 80286) and is mostly used by in-circuit 
> emulators (hence the name GDB uses).


Right, in fact it was quite easy to find any documentation about it, it's
just officially undocumented.

