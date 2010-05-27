Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130Ab0E0Q2i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 12:28:38 -0400
Received: from ist.d-labs.de ([213.239.218.44]:50870 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757571Ab0E0Q2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 12:28:37 -0400
Date: Thu, 27 May 2010 18:28:31 +0200
From: Florian Mickler <florian@mickler.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Arve =?ISO-8859-15?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Vitaly Wool <vitalywool@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100527182831.172215f6@schatten.dmk.lab>
In-Reply-To: <20100527161054.203663ca@lxorguk.ukuu.org.uk>
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
	<20100527161054.203663ca@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010 16:10:54 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> The reality is you need a sane, generic, race free way to express your
> requirements (eg for hard RT) and ditto for constraining the expression
> (for 'crapplications')

And the thing is, even a well written app can be a 'crapplication'
depending on the context and mood of the user.

cheers,
Flo
