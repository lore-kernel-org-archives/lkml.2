Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005Ab0E0PHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 11:07:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:58156 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222Ab0E0PHt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 11:07:49 -0400
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: Peter Zijlstra <peterz@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
In-Reply-To: <20100527161054.203663ca@lxorguk.ukuu.org.uk>
References: <20100526120242.5c9b73ad@schatten.dmk.lab>
	 <AANLkTim4021cTnhVZrQpefq1MG-eEPOFLDRO-XDepHb4@mail.gmail.com>
	 <20100526133721.602633b2@schatten.dmk.lab>
	 <AANLkTikzgaOFdQKess4E-D86OLPOzxP3dWiDkU_UR0ri@mail.gmail.com>
	 <20100526142430.327ccbc4@schatten.dmk.lab>
	 <20100526141612.3e2e0443@lxorguk.ukuu.org.uk>
	 <AANLkTin97MMu-XO_Lk-snefBWz2ymhS0Qi1y1RxLwdVA@mail.gmail.com>
	 <20100527003943.07c17f85@lxorguk.ukuu.org.uk>
	 <20100527140655.GA28048@srcf.ucam.org> <1274970531.27810.5024.camel@twins>
	 <20100527143508.GA30117@srcf.ucam.org> <1274971317.27810.5070.camel@twins>
	 <1274971437.27810.5078.camel@twins>
	 <20100527161054.203663ca@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 27 May 2010 17:07:40 +0200
Message-ID: <1274972860.27810.5156.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-27 at 16:10 +0100, Alan Cox wrote:
> > > Heck, for all I care, simply SIGKILL the thing and report it once the
> > > user starts looking at his screen again.
> > 
> > Provide incentive for Joe Clicker to improve his app, instead of cope
> > with the shit he created.
> 
> That isn't helpful. But if you feel like that I suggest you run with your
> memory management protection disabled, it's really on there to deal with
> crap code and its giving the wrong incentives. Come to think of it
> you might want to remove your seatbelts and any safety catches or airbags
> - it only encourages carelessness.
> 
> The reality is you need a sane, generic, race free way to express your
> requirements (eg for hard RT) and ditto for constraining the expression
> (for 'crapplications')
> 
> Arguing that you don't need to do this isn't useful. Android has
> demonstrated a need to do this. RT has a need to do some of this.
> Virtualisation wants elements of this etc.

Sure, I fully agree with the task and per device QoS stuff. I'm just
saying that its good to inform the user that some app is severely
mis-behaving.
