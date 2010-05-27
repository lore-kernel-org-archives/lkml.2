Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933080Ab0E0R4g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 13:56:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43768 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932966Ab0E0R4e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 13:56:34 -0400
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: Peter Zijlstra <peterz@infradead.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Paul@smtp1.linux-foundation.org, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
In-Reply-To: <20100527175258.GB3543@srcf.ucam.org>
References: <20100527170740.GA1980@srcf.ucam.org>
	 <1274980391.27810.5552.camel@twins> <20100527171644.GA2468@srcf.ucam.org>
	 <1274980856.27810.5582.camel@twins> <20100527172510.GC2468@srcf.ucam.org>
	 <1274981288.27810.5609.camel@twins> <20100527173218.GF2468@srcf.ucam.org>
	 <1274981750.27810.5641.camel@twins> <20100527174140.GB3187@srcf.ucam.org>
	 <1274982397.27810.5679.camel@twins>  <20100527175258.GB3543@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 27 May 2010 19:56:21 +0200
Message-ID: <1274982981.27810.5719.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-27 at 18:52 +0100, Matthew Garrett wrote:

> If that's what you're aiming for then you don't need to block 
> applications on hardware access because they should all already have 
> idled themselves.

Correct, a well behaved app would have. I thought we all agreed that
well behaved apps weren't the problem?

> > Note that it doesn't need to broadcast this, it could opt to reply with
> > that message on the first drawing attempt after it goes away and block
> > on the second.
> 
> That's more interesting, but you're changing semantics quite heavily at 
> this point.

So?
