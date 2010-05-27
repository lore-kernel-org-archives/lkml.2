Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211Ab0E0PDx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 11:03:53 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44544 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754687Ab0E0PDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 11:03:51 -0400
Date: Thu, 27 May 2010 16:10:54 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Arve =?ISO-8859-14?B?SGr4bm5l?= =?ISO-8859-14?B?duVn?= 
	<arve@android.com>,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100527161054.203663ca@lxorguk.ukuu.org.uk>
In-Reply-To: <1274971437.27810.5078.camel@twins>
References: <20100526120242.5c9b73ad@schatten.dmk.lab>
	<AANLkTim4021cTnhVZrQpefq1MG-eEPOFLDRO-XDepHb4@mail.gmail.com>
	<20100526133721.602633b2@schatten.dmk.lab>
	<AANLkTikzgaOFdQKess4E-D86OLPOzxP3dWiDkU_UR0ri@mail.gmail.com>
	<20100526142430.327ccbc4@schatten.dmk.lab>
	<20100526141612.3e2e0443@lxorguk.ukuu.org.uk>
	<AANLkTin97MMu-XO_Lk-snefBWz2ymhS0Qi1y1RxLwdVA@mail.gmail.com>
	<20100527003943.07c17f85@lxorguk.ukuu.org.uk>
	<20100527140655.GA28048@srcf.ucam.org>
	<1274970531.27810.5024.camel@twins>
	<20100527143508.GA30117@srcf.ucam.org>
	<1274971317.27810.5070.camel@twins>
	<1274971437.27810.5078.camel@twins>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Heck, for all I care, simply SIGKILL the thing and report it once the
> > user starts looking at his screen again.
> 
> Provide incentive for Joe Clicker to improve his app, instead of cope
> with the shit he created.

That isn't helpful. But if you feel like that I suggest you run with your
memory management protection disabled, it's really on there to deal with
crap code and its giving the wrong incentives. Come to think of it
you might want to remove your seatbelts and any safety catches or airbags
- it only encourages carelessness.

The reality is you need a sane, generic, race free way to express your
requirements (eg for hard RT) and ditto for constraining the expression
(for 'crapplications')

Arguing that you don't need to do this isn't useful. Android has
demonstrated a need to do this. RT has a need to do some of this.
Virtualisation wants elements of this etc.

The question is how you do it right.
