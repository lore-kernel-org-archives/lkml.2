Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab2DNJSM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 05:18:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:58416 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab2DNJSK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 05:18:10 -0400
Message-ID: <1334395065.2528.43.camel@twins>
Subject: Re: sched: WARNING: at include/linux/cpumask.h:108
 select_fallback_rq+0x241/0x280()
From: Peter Zijlstra <peterz@infradead.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Sasha Levin <levinsasha928@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, mingo@kernel.org,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>, vapier@gentoo.org,
        rusty@rustcorp.com.au
Date: Sat, 14 Apr 2012 11:17:45 +0200
In-Reply-To: <4F76B7B9.5080709@linux.vnet.ibm.com>
References: <CA+1xoqcf6qJOouKXGEHsjWSBJdA7qtMnuVopq+hoHS+TX8fvSg@mail.gmail.com>
	 <CA+1xoqcJAwgTgQG=nZPsH_SLkPFkGt2rUiVWGn5SO5JOAC1RAA@mail.gmail.com>
	 <4F75BED4.9050005@linux.vnet.ibm.com> <1333118719.2960.27.camel@laptop>
	 <4F76B7B9.5080709@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-03-31 at 13:22 +0530, Srivatsa S. Bhat wrote:
> 
> One of the perils of using macros instead of true function calls :-(
> 
You can do type checking in macros too, its not pretty, but there's
several such things already, see min()/max() for example.


