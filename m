Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab0EZNbA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 09:31:00 -0400
Received: from ist.d-labs.de ([213.239.218.44]:40916 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691Ab0EZNa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 09:30:57 -0400
Date: Wed, 26 May 2010 15:30:52 +0200
From: Florian Mickler <florian@mickler.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: felipe.balbi@nokia.com, Vitaly Wool <vitalywool@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Paul@smtp1.linux-foundation.org" <Paul@smtp1.linux-foundation.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100526153052.3b95621d@schatten.dmk.lab>
In-Reply-To: <1274879247.27810.390.camel@twins>
References: <87wrusvrqe.fsf@deeprootsystems.com>
	<201005250138.16293.rjw@sisk.pl>
	<1274863655.5882.4875.camel@twins>
	<AANLkTinN6MKvCEhPkbYQRD2gu-mGXdNW9asRsTuKN3_Y@mail.gmail.com>
	<1274867106.5882.5090.camel@twins>
	<20100526120242.5c9b73ad@schatten.dmk.lab>
	<AANLkTim4021cTnhVZrQpefq1MG-eEPOFLDRO-XDepHb4@mail.gmail.com>
	<20100526133721.602633b2@schatten.dmk.lab>
	<AANLkTikzgaOFdQKess4E-D86OLPOzxP3dWiDkU_UR0ri@mail.gmail.com>
	<20100526142430.327ccbc4@schatten.dmk.lab>
	<20100526122932.GB1990@nokia.com>
	<20100526143323.7c6f8705@schatten.dmk.lab>
	<1274877689.27810.287.camel@twins>
	<20100526150348.54ea29c7@schatten.dmk.lab>
	<1274879247.27810.390.camel@twins>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 May 2010 15:07:27 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, 2010-05-26 at 15:03 +0200, Florian Mickler wrote:
> > The kernel can not win if it does not try to integrate any use of it.
> 
> If we'd integrate every patch that came to lkml, you'd run away
> screaming.
> 
> We most certainly do not want to integrate _any_ use.

We most certainly do want to integrate any use that is not harmful to
others.

I don't buy the argument that this is harmful. 

Cheers,
Flo
