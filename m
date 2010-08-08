Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab0HHQJR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 12:09:17 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:60893 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235Ab0HHQJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 12:09:16 -0400
Date: Sun, 8 Aug 2010 17:08:10 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: "Ted Ts'o" <tytso@mit.edu>, david@lang.hm,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Brian Swetland <swetland@google.com>,
        kevin granade <kevin.granade@gmail.com>,
        Arve Hj?nnev?g <arve@android.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
Message-ID: <20100808160810.GA7968@srcf.ucam.org>
References: <alpine.DEB.2.00.1008051800360.25170@asgard.lang.hm> <20100806123047.GE31326@sirena.org.uk> <20100806172226.GH2432@linux.vnet.ibm.com> <20100806173325.GA25367@rakim.wolfsonmicro.main> <20100806181832.GJ2432@linux.vnet.ibm.com> <alpine.DEB.2.00.1008061517130.30564@asgard.lang.hm> <20100807001431.GA3252@opensource.wolfsonmicro.com> <alpine.DEB.2.00.1008061741460.30564@asgard.lang.hm> <20100807062828.GB28087@thunk.org> <AANLkTinTfKRfAUJqggcK9Cgo9BTXfqMjJ2SXZS=D1bmT@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinTfKRfAUJqggcK9Cgo9BTXfqMjJ2SXZS=D1bmT@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 08, 2010 at 04:35:13PM +0300, Felipe Contreras wrote:

> appropriately; that's not the case.
> 
> 1) Install a bad application that requests PM permissions and is granted those
> 
> In this case you've gained nothing with user-space suspend blockers.

It's clearly possible for a pathological Android application to destroy 
the power management policy. But to do that, the author would have to 
explicitly take a wakelock. That's difficult to do by accident. The 
various failure modes that exist in a non-wakelock world can be 
triggered in a wide variety of ways by accident. A sufficiently 
reductionist viewpoint will equate the two situations, but in the real 
world they're clearly different.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
