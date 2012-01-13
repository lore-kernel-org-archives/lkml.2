Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759453Ab2AMXNz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 18:13:55 -0500
Received: from mga02.intel.com ([134.134.136.20]:55372 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756145Ab2AMXNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 18:13:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="98292684"
Message-ID: <4F10BAB0.70308@linux.intel.com>
Date: Fri, 13 Jan 2012 15:13:52 -0800
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Ming Lei <tom.leiming@gmail.com>, Djalal Harouni <tixxdz@opendz.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Tony Luck <tony.luck@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>,
        gouders@et.bocholt.fh-gelsenkirchen.de,
        Marcos Souza <marcos.mage@gmail.com>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "tglx@linutronix.de" <tglx@linutronix.de>, prasad@linux.vnet.ibm.com,
        justinmattock@gmail.com, Jeff Chua <jeff.chua.linux@gmail.com>
Subject: Re: x86/mce: machine check warning during poweroff
References: <20120111000051.GA28874@dztty> <CACVXFVMZhVFZajbZxng9dJqicy1XCK5n_QZLoefvkLkXvMsSZg@mail.gmail.com> <4F10929E.8070007@linux.vnet.ibm.com> <CA+55aFwcOgEbnYhs7z+jc-Jq+fWxV3vfSRdfLXBEUC_40BRK0w@mail.gmail.com> <4F1099CA.7090209@linux.vnet.ibm.com> <CA+55aFw9SkNPoMmad6sOAsY-jtJtes12pBFGr9sipGadS8+VJg@mail.gmail.com> <4F10A0FD.9040504@linux.intel.com>
In-Reply-To: <4F10A0FD.9040504@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Assuming the problem is with the multiple devices (not fully sure):
>
> The redundant devices don't make much sense anyways, they are all 
> mirrors of each other
> (state changes always affect all CPUs)  Could just collapse down to a 
> single device and symlink
> the others.

Checking again it seems like the AMD threshold code reports per CPU 
counters so it would
still need per CPU devices.

All the other code is just a single instance I believe and doesn't 
actually need all the
complicated per CPU code.

-Andi


