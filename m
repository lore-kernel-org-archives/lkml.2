Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328Ab2DLFVz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 01:21:55 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59811 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754588Ab2DLFVw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 01:21:52 -0400
From: "Shankarmurthy, Akshay" <akshay.s@ti.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>,
        "jamie@jamieiles.com" <jamie@jamieiles.com>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        "dianders@chromium.org" <dianders@chromium.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] serial: 8250: Add cpufreq support
Thread-Topic: [PATCH] serial: 8250: Add cpufreq support
Thread-Index: AQHNEWH/ogbkcH+7O02pQ5jFyo8I/ZaIgNYAgAN273D//73mAIAK/Rkg
Date: Thu, 12 Apr 2012 05:21:31 +0000
Message-ID: <6F6B80BD2E18844D97BB4B51FE3705C83179146B@DBDE01.ent.ti.com>
References: <1333433022-5455-1-git-send-email-akshay.s@ti.com>
	<20120403105530.7fa3bce7@pyramind.ukuu.org.uk>
	<6F6B80BD2E18844D97BB4B51FE3705C831790EA0@DBDE01.ent.ti.com>
 <20120405115322.15e6088c@pyramind.ukuu.org.uk>
In-Reply-To: <20120405115322.15e6088c@pyramind.ukuu.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: GlL2 JEos T/5d WhwC mwvB ox88 rjuj 4oKk 7uOg AAsDqQ==
 ABN7QA== AB63Kg== AGB0nw== AHO5Qw== AKeLcQ==
 ALKm2g==;10;YQBsAGEAbgBAAGwAaQBuAHUAeAAuAGkAbgB0AGUAbAAuAGMAbwBtADsAYQBsAGEAbgBAAGwAeABvAHIAZwB1AGsALgB1AGsAdQB1AC4AbwByAGcALgB1AGsAOwBkAGEAdgBpAG4AYwBpAC0AbABpAG4AdQB4AC0AbwBwAGUAbgAtAHMAbwB1AHIAYwBlAEAAbABpAG4AdQB4AC4AZABhAHYAaQBuAGMAaQBkAHMAcAAuAGMAbwBtADsAZABpAGEAbgBkAGUAcgBzAEAAYwBoAHIAbwBtAGkAdQBtAC4AbwByAGcAOwBnAHIAZQBnAGsAaABAAGwAaQBuAHUAeABmAG8AdQBuAGQAYQB0AGkAbwBuAC4AbwByAGcAOwBqAGEAbQBpAGUAQABqAGEAbQBpAGUAaQBsAGUAcwAuAGMAbwBtADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AGwAaQBuAHUAeAAtAHMAZQByAGkAYQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBwAGEAdQBsAC4AZwBvAHIAdABtAGEAawBlAHIAQAB3AGkAbgBkAHIAaQB2AGUAcgAuAGMAbwBtADsAcwB3AGEAcgByAGUAbgBAAG4AdgBpAGQAaQBhAC4AYwBvAG0A;Sosha1_v1;7;{8FBA260A-9119-41F0-BA77-7289A13F152D};YQBrAHMAaABhAHkALgBzAEAAdABpAC4AYwBvAG0A;Thu,
 12 Apr 2012 05:21:04
 GMT;UgBFADoAIABbAFAAQQBUAEMASABdACAAcwBlAHIAaQBhAGwAOgAgADgAMgA1ADAAOgAgAEEAZABkACAAYwBwAHUAZgByAGUAcQAgAHMAdQBwAHAAbwByAHQA
x-cr-puzzleid: {8FBA260A-9119-41F0-BA77-7289A13F152D}
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, Apr 05, 2012 at 16:23:22, Alan Cox wrote:
> On Thu, 5 Apr 2012 10:40:55 +0000
> "Shankarmurthy, Akshay" <akshay.s@ti.com> wrote:
> 
> > Hi,
> > 
> > On Tue, Apr 03, 2012 at 15:25:30, Alan Cox wrote:
> > > > This patch was submitted 2 years ago but didn't make it to the mainline. Now i am reposting it.
> > > 
> > > Can you fix it instead of just reposting it ?
> > > 
> > > 
> > > > +#ifdef CONFIG_CPU_FREQ
> > > > +static int serial8250_cpufreq_transition(struct notifier_block *nb,
> > > > +					     unsigned long val, void *data) {
> > > > +	struct uart_8250_port *p;
> > > > +	struct uart_port *uport;
> > > 
> > > What is your locking model ?
> > > 
> > 
> > I will have a look at this and add the lock if necessary.
> 
> At the very least you need reference counts held on the tty struct and to allow for the tty having vanished under you.
> 

I am planning to add "tty->termios_mutex" lock. Any comments ?

> > > 
> > > > +static inline void serial8250_cpufreq_deregister(struct 
> > > > +uart_8250_port *p)
> > > 
> > > unregister
> > 
> > Ok. I will change it.
> > 
> > > 
> > > > +		ret = serial8250_cpufreq_register(uart);
> > > > +		if (ret < 0)
> > > > +			printk(KERN_ERR "Failed to add cpufreq notifier\n");
> > > 
> > > Why do this for devices that don't care.
> > 
> > This is taken care in the code. If the device's frequency doesn't 
> > change after the change in the cpu frequency then it doesn't go for execution of the function "serial8250_set_termios".
> 
> But you still call each function and walk the list for each port on each CPU transition. There are people with 128 ports in their systems and the cpu frequency change is latency critical.
> 
> Nothing should even be getting registered in such cases.
> 

I understand this and planning to avoid unnecessary registration like these. 
As a solution, UART port's cpu freq status will be sent from the board file.
Adding a member to the structure "plat_serial8250_port" which says whether
a port requires cpu freq registration or not. cpu freq register function is
called in the driver depending upon the status of this structure member.
I can update the patch accordingly and send out a version 2 to the list.

Regards,
Akshay

