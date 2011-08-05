Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570Ab1HESUx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 14:20:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753990Ab1HESUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 14:20:51 -0400
Date: Fri, 5 Aug 2011 14:20:09 -0400
From: Dave Jones <davej@redhat.com>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: list corruption in the last few days. (block ? crypto ?)
Message-ID: <20110805182008.GA22314@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jens Axboe <jaxboe@fusionio.com>
References: <20110805010038.GA18148@redhat.com>
 <20110805084614.GA1588@x4.trippels.de>
 <CAOJsxLEMf8SbSmJv5u6GZtq_OYH3fpmomT-ioWXQGp83veK7wQ@mail.gmail.com>
 <alpine.DEB.2.00.1108051131440.28580@router.home>
 <20110805163948.GA11113@redhat.com>
 <alpine.DEB.2.00.1108051146180.28580@router.home>
 <20110805165119.GA11593@redhat.com>
 <alpine.DEB.2.00.1108051158400.28580@router.home>
 <20110805171607.GA11703@redhat.com>
 <alpine.DEB.2.00.1108051312090.28580@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1108051312090.28580@router.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 05, 2011 at 01:14:50PM -0500, Christoph Lameter wrote:
 > On Fri, 5 Aug 2011, Dave Jones wrote:
 > 
 > >  > Argh another debugging code issue. Anyone who sees this please verify that
 > >  > it also occurs with debugging off. I ran this code for 9 months in
 > >  > various configs but only sporadically with debugging support since that
 > >  > switches the lockless stuff.
 > >
 > > This started turning up immediately as soon as it got merged to mainline.
 > > Which leads me to believe no-one is running -next with debugging on either.
 > > Perhaps we should force debugging on for a week once per release cycle.
 > 
 > I have run some tests over the last hours with kvm and
 > CONFIG_SLUB_DEBUG_ON as well as CONFIG_DEBUG_LIST set but (aside from
 > other unrelated backtraces in other subsystems) did not see this issue.
 > 
 > Can I get a .config? Maybe that will help.

http://codemonkey.org.uk/junk/adamo.config

	Dave
