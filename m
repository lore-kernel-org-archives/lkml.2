Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759594Ab0E0T4g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 15:56:36 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:32929 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759552Ab0E0T4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 15:56:35 -0400
Date: Thu, 27 May 2010 21:03:33 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Arve =?ISO-8859-14?B?SGr4bm5l?= =?ISO-8859-14?B?duVn?= 
	<arve@android.com>,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, Paul@smtp1.linux-foundation.org,
       felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100527210333.4b09dfe2@lxorguk.ukuu.org.uk>
In-Reply-To: <20100527182633.GN3543@srcf.ucam.org>
References: <AANLkTin97MMu-XO_Lk-snefBWz2ymhS0Qi1y1RxLwdVA@mail.gmail.com>
	<20100527003943.07c17f85@lxorguk.ukuu.org.uk>
	<20100527140655.GA28048@srcf.ucam.org>
	<alpine.LFD.2.00.1005271642440.3032@localhost.localdomain>
	<20100527155201.GA31937@srcf.ucam.org>
	<alpine.LFD.2.00.1005271808340.3032@localhost.localdomain>
	<20100527165931.GB1062@srcf.ucam.org>
	<alpine.LFD.2.00.1005271905000.3032@localhost.localdomain>
	<20100527172343.GB2468@srcf.ucam.org>
	<alpine.LFD.2.00.1005271930350.3032@localhost.localdomain>
	<20100527182633.GN3543@srcf.ucam.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We were talking about PCs. Suspend-as-c-state is already implemented for 
> OMAP.

"You" were talking about PCs. Some of us are interested in the making
Linux do the right thing not adding platform specific hacks all over the
userspace of all the apps.
 
> > So the only thing you are imposing to app writers is to use an
> > interface which solves nothing and does not save you any power at
> > all. 
> 
> It's already been demonstrated that the Android approach saves power.

So do lots of other things

> > Runnable tasks and QoS guarantees are the indicators whether you can
> > go to opportunistic suspend or not. Everything else is just window
> > dressing.
> 
> As I keep saying, this is all much less interesting if you don't care 
> about handling suboptimal applications. If you do care about them then 

I don't believe the Android one does either. It maybe handles a subset in
a specific case.

> the Android approach works. Nobody has demonstrated a scheduler-based 
> one that does.

I would point you at the web, cgi scripts and the huge Linux server farms
fielding billions of hits per second on crap cgi scripts.

That doesn't mean the Android one is the right approach. Nobody has
explained to me how you don't get synchronization effects in Android or
indeed answered several of the questions pointing out holes in the
Android model. The fact we are at rev 8 says something too - that the
Android 'proof' isn't old or tested either !

Alan
