Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506Ab0HJSOP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 14:14:15 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:55565 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932271Ab0HJSOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 14:14:11 -0400
Date: Tue, 10 Aug 2010 19:13:20 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: david@lang.hm
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, paulmck@linux.vnet.ibm.com,
        "Ted Ts'o" <tytso@mit.edu>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Brian Swetland <swetland@google.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, pavel@ucw.cz, florian@mickler.org, rjw@sisk.pl,
        stern@rowland.harvard.edu, peterz@infradead.org, tglx@linutronix.de,
        menage@google.com, david-b@pacbell.net, James.Bottomley@suse.de,
        arjan@infradead.org, swmike@swm.pp.se, galibert@pobox.com,
        dipankar@in.ibm.com
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
Message-ID: <20100810181320.GA17472@srcf.ucam.org>
References: <20100808155719.GB3635@thunk.org> <AANLkTinM5e2HGOFavODPZNzZx4KshDSjsvKN4pLpGGgr@mail.gmail.com> <20100808213821.GD3635@thunk.org> <20100809112453.77210acc@lxorguk.ukuu.org.uk> <20100809181638.GI3026@linux.vnet.ibm.com> <20100809201822.441905f7@lxorguk.ukuu.org.uk> <20100810044541.GA2817@linux.vnet.ibm.com> <20100810093849.138e2318@lxorguk.ukuu.org.uk> <20100810141107.GA12873@srcf.ucam.org> <alpine.DEB.2.00.1008101057090.23481@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1008101057090.23481@asgard.lang.hm>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 10, 2010 at 11:07:20AM -0700, david@lang.hm wrote:

> If the primary difference between sleep and suspend is not scheduling  
> processes, instead of messing with oppurtinistic suspend/suspend  
> blockers/wakelocks/etc, why not just 'temporarily' change the timer fuzz  
> value to a very large value (say an hour). That would still let things  
> like openoffice saves ahve a fair chance to trigger before the battery  
> died completely, but would wake the system so infrequently that it will 
> be effectivly the same as a full suspend.

Because it only affects processes that sleep. It's a question of how 
much pathology you want to be able to tolerate.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
