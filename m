Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569Ab1CCJaH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 04:30:07 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:41953 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756096Ab1CCJaE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 04:30:04 -0500
From: "TK, Pratheesh Gangadhar" <pratheesh@ti.com>
To: Thomas Gleixner <tglx@linutronix.de>, Arnd Bergmann <arnd@arndb.de>
CC: "Hans J. Koch" <hjk@hansjkoch.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "sshtylyov@mvista.com" <sshtylyov@mvista.com>,
        "Chatterjee, Amit" <amit.chatterjee@ti.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 3 Mar 2011 14:59:42 +0530
Subject: RE: [PATCH v8 1/1] PRUSS UIO driver support
Thread-Topic: [PATCH v8 1/1] PRUSS UIO driver support
Thread-Index: AcvZHGn2vBdWMnyASoeDeag0ubpRiQAaGU6A
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024C008731@dbde02.ent.ti.com>
References: <1299065886-30099-1-git-send-email-pratheesh@ti.com>
 <1299065886-30099-2-git-send-email-pratheesh@ti.com>
 <20110302200956.GB23818@local> <201103022123.38050.arnd@arndb.de>
 <alpine.LFD.2.00.1103022155030.2701@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1103022155030.2701@localhost6.localdomain6>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,
> -----Original Message-----
> From: Thomas Gleixner [mailto:tglx@linutronix.de]
> Sent: Thursday, March 03, 2011 2:27 AM
> On Wed, 2 Mar 2011, Arnd Bergmann wrote:
> 
> > On Wednesday 02 March 2011 21:09:56 Hans J. Koch wrote:
> > > > +static struct uio_info *info;
> > > > +static dma_addr_t sram_paddr, ddr_paddr;
> > > > +static void *prussio_vaddr, *sram_vaddr, *ddr_vaddr;
> > >
> > > So the correct thing would be
> > >
> > > static void __iomem *prussio_vaddr;
> > > static void *sram_vaddr, *ddr_vaddr;
> >
> > I also commented that it should not be a global variable at
> > all, but a dynamic data structure referenced from the device.
> >
> > Not important, but Pratheesh said he'd change it. If it stays
> > a global variable, I'd at least expect an explanation why
> > the static variable is considered better in this case.
> 
> I did not pick at that, because there is no indicator that we'll see
> more than one PRUSS unit per SoC in the forseeable future.
> 
It's a possibility - May be in 2-3 years time.

Thanks,
Pratheesh

