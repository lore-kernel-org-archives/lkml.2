Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078Ab0HDFHl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 01:07:41 -0400
Received: from dspnet.fr ([188.165.44.67]:32415 "EHLO dspnet.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753975Ab0HDFHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 01:07:40 -0400
X-Greylist: delayed 561 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Aug 2010 01:07:40 EDT
Date: Wed, 4 Aug 2010 06:58:13 +0200
From: Olivier Galibert <galibert@pobox.com>
To: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>
Cc: david@lang.hm, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@infradead.org>, "Ted Ts'o" <tytso@mit.edu>,
        linux-pm@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>, mjg59@srcf.ucam.org,
        pavel@ucw.cz, florian@mickler.org, rjw@sisk.pl,
        stern@rowland.harvard.edu, swetland@google.com, peterz@infradead.org,
        tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
Message-ID: <20100804045813.GA33951@dspnet.fr>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinjH0C0bSK=Y2wKASnbJFsR2BN303xBXkaHbmRC@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 08:39:22PM -0700, Arve Hjønnevåg wrote:
> If you just program the alarm you will wake up see that the monotonic
> clock has not advanced and set the alarm another n seconds into the
> future. Or are proposing that suspend should be changed to keep the
> monotonic clock running?

You're supposed to fix the clock after you wake up.  That's part of
the cost of going suspend.

  OG.

