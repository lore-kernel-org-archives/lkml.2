Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539Ab2AWIn5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 03:43:57 -0500
Received: from casper.infradead.org ([85.118.1.10]:52783 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160Ab2AWIn4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 03:43:56 -0500
Message-ID: <1327308202.2442.253.camel@twins>
Subject: Re: x86/mce: machine check warning during poweroff
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ming Lei <tom.leiming@gmail.com>, Djalal Harouni <tixxdz@opendz.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Tony Luck <tony.luck@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>,
        gouders@et.bocholt.fh-gelsenkirchen.de,
        Marcos Souza <marcos.mage@gmail.com>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "tglx@linutronix.de" <tglx@linutronix.de>, prasad@linux.vnet.ibm.com,
        justinmattock@gmail.com, Jeff Chua <jeff.chua.linux@gmail.com>,
        Mel Gorman <mgorman@suse.de>, Gilad Ben-Yossef <gilad@benyossef.com>
Date: Mon, 23 Jan 2012 09:43:22 +0100
In-Reply-To: <1327026538.16150.40.camel@sbsiddha-desk.sc.intel.com>
References: <CACVXFVMZhVFZajbZxng9dJqicy1XCK5n_QZLoefvkLkXvMsSZg@mail.gmail.com>
	 <4F10929E.8070007@linux.vnet.ibm.com>
	 <CA+55aFzGZ_eSTChemYczKr3-0zQ3J3MJ3TfGtxh9wkhSKrrfCA@mail.gmail.com>
	 <4F10BDF7.8030306@linux.vnet.ibm.com>
	 <CA+55aFyD=9MZCyo-Tq0J7g2p9Qvp=S+GADpUfoQ0dcde_bvzSg@mail.gmail.com>
	 <4F10EB5B.5060804@linux.vnet.ibm.com>
	 <1326766892.16150.21.camel@sbsiddha-desk.sc.intel.com>
	 <4F1544EA.5060907@linux.vnet.ibm.com>
	 <1326856624.5291.20.camel@sbsiddha-mobl2>
	 <4F16C60B.4030903@linux.vnet.ibm.com>
	 <20120118133236.GA3878@swordfish.minsk.epam.com>
	 <1326924509.13915.29.camel@sbsiddha-mobl2>
	 <4F18066D.9050102@linux.vnet.ibm.com>
	 <1327026538.16150.40.camel@sbsiddha-desk.sc.intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-19 at 18:28 -0800, Suresh Siddha wrote:
> Ingo, Peterz, can you please queue this appended patch for 3.3?

Thanks Suresh!
