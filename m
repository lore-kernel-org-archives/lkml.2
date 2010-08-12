Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759807Ab0HLKrn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 06:47:43 -0400
Received: from DMZ-MAILSEC-SCANNER-6.MIT.EDU ([18.7.68.35]:44330 "EHLO
	dmz-mailsec-scanner-6.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759753Ab0HLKrm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 06:47:42 -0400
X-AuditID: 12074423-b7cb4ae000000a9b-57-4c63d1412b6a
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <AANLkTi=RD=eM_gpc7FfRq0923sUbARmZ2+4-m+fLibYC@mail.gmail.com>
Date: Thu, 12 Aug 2010 06:47:27 -0400
Cc: paulmck@linux.vnet.ibm.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        david@lang.hm, Brian Swetland <swetland@google.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, menage@google.com,
        david-b@pacbell.net, James.Bottomley@suse.de, arjan@infradead.org,
        swmike@swm.pp.se, galibert@pobox.com, dipankar@in.ibm.com
Content-Transfer-Encoding: 8BIT
Message-Id: <E3F3D3E1-4DF7-47E3-895D-95F6BC22CCC4@mit.edu>
References: <20100808155719.GB3635@thunk.org> <AANLkTinM5e2HGOFavODPZNzZx4KshDSjsvKN4pLpGGgr@mail.gmail.com> <20100808213821.GD3635@thunk.org> <20100809112453.77210acc@lxorguk.ukuu.org.uk> <20100809181638.GI3026@linux.vnet.ibm.com> <AANLkTikwHaKpLdRdxmZj6JDJnsZ+o-jzbVcXhRW3Jmd9@mail.gmail.com> <20100811222854.GJ2516@linux.vnet.ibm.com> <AANLkTimahmGikeai8QnAxCy45deT00-6T7h-eA-NqL4G@mail.gmail.com> <20100812010612.GL2516@linux.vnet.ibm.com> <AANLkTinVV1NVHFPeO0p_e2pCtNwTNB932q9tbu9MMD3_@mail.gmail.com> <20100812034435.GA7403@linux.vnet.ibm.com> <AANLkTi=RD=eM_gpc7FfRq0923sUbARmZ2+4-m+fLibYC@mail.gmail.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
X-Mailer: Apple Mail (2.1081)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe,

One thing I'm not clear on --- what's your goal?   Is your goal to keep suspend-blockers out of the kernel?   Is it to try to convince the android team suspend-blockers are a bad idea and to change Android to not use them?  Is it to push some other agenda?  Is it to discourage the Android team from trying to waste more time trying to get suspend-blockers (or equivalent functionality) from being added into the kernel?

You seem to be arguing quite passionately, but I'm not sure what you're trying to do.

-- Ted

