Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236Ab0HDFqq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 01:46:46 -0400
Received: from ist.d-labs.de ([213.239.218.44]:60670 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613Ab0HDFqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 01:46:45 -0400
Date: Wed, 4 Aug 2010 07:46:28 +0200
From: Florian Mickler <florian@mickler.org>
To: david@lang.hm
Cc: Arve =?ISO-8859-15?Q?Hj=F8nnev=E5g?= <arve@android.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@infradead.org>, "Ted Ts'o" <tytso@mit.edu>,
        linux-pm@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>, mjg59@srcf.ucam.org,
        pavel@ucw.cz, rjw@sisk.pl, stern@rowland.harvard.edu,
        swetland@google.com, peterz@infradead.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
Message-ID: <20100804074628.4acc0ed2@schatten.dmk.lab>
In-Reply-To: <alpine.DEB.2.00.1008032111350.25170@asgard.lang.hm>
References: <20100801210548.23f77ff6@infradead.org>
	<alpine.DEB.2.00.1008012153300.25170@asgard.lang.hm>
	<20100802140933.GB2405@linux.vnet.ibm.com>
	<alpine.DEB.2.00.1008021627290.29820@asgard.lang.hm>
	<AANLkTi=1kBuyPS_P+eNLcnRu1mJH6BzpzQW_sENZuL1L@mail.gmail.com>
	<alpine.DEB.2.00.1008022121430.6545@asgard.lang.hm>
	<AANLkTikhcYzNp8CPp8cqrV7Ey5CLMWu1sJTNxUtEi2as@mail.gmail.com>
	<alpine.DEB.2.00.1008022203470.6545@asgard.lang.hm>
	<AANLkTinFT5jq4nUhUpzS5S4TVDQGj0S7RtRgxNhsz2UF@mail.gmail.com>
	<alpine.DEB.2.00.1008031611100.6545@asgard.lang.hm>
	<20100804001015.GJ2407@linux.vnet.ibm.com>
	<alpine.DEB.2.00.1008031723530.6545@asgard.lang.hm>
	<AANLkTinjH0C0bSK=Y2wKASnbJFsR2BN303xBXkaHbmRC@mail.gmail.com>
	<alpine.DEB.2.00.1008032111350.25170@asgard.lang.hm>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 3 Aug 2010 21:47:49 -0700 (PDT)
david@lang.hm wrote:

> > Suspend is not an android only concept. The android extensions just
> > allow us to aggressively use suspend without loosing (or delaying)
> > wakeup events. On the hardware that we shipped we can enter the same
> > power mode from idle as we do in suspend, but we still use suspend
> > primarily because it stops the monotonic clock and all the timers that
> > use it. Changing suspend to behave more like an idle mode, which seems
> > to be what you are suggesting, would not buy us anything.
> 
> Ok, If I am understanding you correctly I think this is an important 
> point.
> 
> What Android calls suspend is not what other linux distros call suspend, 
> it's just a low-power mode with different wakeup rules.
> 
> Is this correct?

I think my laptop (x86-64) uses the same notion of suspend as Android.
I am confused now. Android 'suspend' is equivalent to 
'echo "mem" > /sys/power/state' 
 
Which distros call it "low-power mode with different wakeup rules"?
Gentoo doesnt. In KDE/Gnome it's also called suspend or suspend-to-ram
iirc. 



Cheers,
Flo






