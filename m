Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758275Ab0HDGDS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 02:03:18 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53577 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758197Ab0HDGDQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 02:03:16 -0400
MIME-Version: 1.0
In-Reply-To: <20100804045813.GA33951@dspnet.fr>
References: <alpine.DEB.2.00.1008021627290.29820@asgard.lang.hm>
	<AANLkTi=1kBuyPS_P+eNLcnRu1mJH6BzpzQW_sENZuL1L@mail.gmail.com>
	<alpine.DEB.2.00.1008022121430.6545@asgard.lang.hm>
	<AANLkTikhcYzNp8CPp8cqrV7Ey5CLMWu1sJTNxUtEi2as@mail.gmail.com>
	<alpine.DEB.2.00.1008022203470.6545@asgard.lang.hm>
	<AANLkTinFT5jq4nUhUpzS5S4TVDQGj0S7RtRgxNhsz2UF@mail.gmail.com>
	<alpine.DEB.2.00.1008031611100.6545@asgard.lang.hm>
	<20100804001015.GJ2407@linux.vnet.ibm.com>
	<alpine.DEB.2.00.1008031723530.6545@asgard.lang.hm>
	<AANLkTinjH0C0bSK=Y2wKASnbJFsR2BN303xBXkaHbmRC@mail.gmail.com>
	<20100804045813.GA33951@dspnet.fr>
Date: Tue, 3 Aug 2010 23:03:15 -0700
Message-ID: <AANLkTi=pwyidtK7aebRwZ+SsJCSS-6t=6cFffdvcKKnx@mail.gmail.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Olivier Galibert <galibert@pobox.com>
Cc: david@lang.hm, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@infradead.org>, "Ted Ts'o" <tytso@mit.edu>,
        linux-pm@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>, mjg59@srcf.ucam.org,
        pavel@ucw.cz, florian@mickler.org, rjw@sisk.pl,
        stern@rowland.harvard.edu, swetland@google.com, peterz@infradead.org,
        tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/3 Olivier Galibert <galibert@pobox.com>:
> On Tue, Aug 03, 2010 at 08:39:22PM -0700, Arve Hjønnevåg wrote:
>> If you just program the alarm you will wake up see that the monotonic
>> clock has not advanced and set the alarm another n seconds into the
>> future. Or are proposing that suspend should be changed to keep the
>> monotonic clock running?
>
> You're supposed to fix the clock after you wake up.  That's part of
> the cost of going suspend.

I'm not sure what you are referring to. The generic Linux timekeeping
code makes sure the monotonic clock stops while the system is
suspended regardless of what values the (hardware specific)
clocksource returns.

-- 
Arve Hjønnevåg
