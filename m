Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933348Ab1FBKNM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 06:13:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:31574 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933189Ab1FBKNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 06:13:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,308,1304319600"; 
   d="scan'208";a="10842083"
Date: Thu, 2 Jun 2011 11:00:24 +0100
From: Alan Cox <alan@linux.intel.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org
Subject: Re: /proc/stat btime accuracy problem
Message-ID: <20110602110024.4d93243b@bob.linux.org.uk>
In-Reply-To: <1306975745.11492.30.camel@work-vm>
References: <BANLkTiniq6GVMJPO_-efKrWHQg9V9Dod9g@mail.gmail.com>
	<1306967733.11492.11.camel@work-vm>
	<BANLkTi=yEMDLEo99WZm2Bt4pi_pog5igww@mail.gmail.com>
	<1306972711.11492.23.camel@work-vm>
	<BANLkTimuPrqN1euyOqAGm2m4Ea1PdbrzDQ@mail.gmail.com>
	<1306975745.11492.30.camel@work-vm>
Organization: Intel
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> CC'ing the linux-serial list and Alan for their thoughts: Does the
> serial port is disabling irqs for 30+ seconds during boot seem at all
> sane?

printk is supposed to work from anywhere so it takes the hit. It should
only be printk that is involved however.

Alan
