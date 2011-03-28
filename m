Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973Ab1C1En6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 00:43:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37834 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681Ab1C1En4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 00:43:56 -0400
Date: Mon, 28 Mar 2011 06:43:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <jaxboe@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] block drivers for 2.6.39-rc
Message-ID: <20110328044352.GA22659@elte.hu>
References: <4D8E36CC.7080707@fusionio.com>
 <20110328042311.GA15481@elte.hu>
 <AANLkTik3GZ0b5S7p4ONQu4Hb8LoKewmMJ7_J5zvumYD-@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTik3GZ0b5S7p4ONQu4Hb8LoKewmMJ7_J5zvumYD-@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sun, Mar 27, 2011 at 9:23 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > This driver does not build at all:
> >
> >  drivers/block/drbd/drbd_bitmap.c:1187:5: error: implicit declaration of function ‘generic_find_next_zero_le_bit’ [-Werror=implicit-function-declaration]
> >  drivers/block/drbd/drbd_bitmap.c:1190:5: error: implicit declaration of function ‘generic_find_next_le_bit’ [-Werror=implicit-function-declaration]
> >  drivers/block/drbd/drbd_bitmap.c:1290:4: error: implicit declaration of function ‘generic___test_and_set_le_bit’ [-Werror=implicit-function-declaration]
> >  drivers/block/drbd/drbd_bitmap.c:1292:4: error: implicit declaration of function ‘generic___test_and_clear_le_bit’ [-Werror=implicit-function-declaration]
> >  drivers/block/drbd/drbd_bitmap.c:1441:3: error: implicit declaration of function ‘generic_test_le_bit’ [-Werror=implicit-function-declaration]
> >
> > Has this been build-tested? These APIs do not exist upstream.
> 
> Actually, I think that's just a merge error - those horrible nasty
> crazy names did use to exist.

Yeah, indeed.

> Does this fix it? (Untested!)

It does, thanks!

Tested-by: Ingo Molnar <mingo@elte.hu>

	Ingo
