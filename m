Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573Ab2F0PQK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 11:16:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:1225 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756108Ab2F0PQI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 11:16:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="185653903"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Lekensteyn <lekensteyn@gmail.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [char-misc fix for 3.5] mei: pci_resume: set IRQF_ONESHOT for
 msi request_threaded_irq
Thread-Topic: [char-misc fix for 3.5] mei: pci_resume: set IRQF_ONESHOT for
 msi request_threaded_irq
Thread-Index: AQHNVG83qy0mLC4Nm0+Uvy67sP+Ft5cOD32AgAA2yyA=
Date: Wed, 27 Jun 2012 15:16:02 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B138D6E@HASMSX103.ger.corp.intel.com>
References: <1340806460-21646-1-git-send-email-tomas.winkler@intel.com>
 <67041533.Myjsgf8nbb@al>
In-Reply-To: <67041533.Myjsgf8nbb@al>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.11]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Lekensteyn [mailto:lekensteyn@gmail.com]
> Sent: Wednesday, June 27, 2012 5:59 PM
> To: Winkler, Tomas
> Cc: gregkh@linuxfoundation.org; arnd@arndb.de; alan@linux.intel.com;
> linux-kernel@vger.kernel.org
> Subject: Re: [char-misc fix for 3.5] mei: pci_resume: set IRQF_ONESHOT for
> msi request_threaded_irq
> 
> On Wednesday 27 June 2012 17:14:20 Tomas Winkler wrote:
> > when the default irq quick handler is used then IRQF_ONESHOT must be
> > set otherwise the request fails and following error is displayed:
> >
> > mei 0000:00:16.0: irq 48 for MSI/MSI-X
> > genirq: Threaded irq requested with handler=NULL and !ONESHOT for irq
> > 48 mei 0000:00:16.0: request_threaded_irq failed: irq = 48.
> > dpm_run_callback(): pci_pm_resume+0x0/0x140 returns -22
> > PM: Device 0000:00:16.0 failed to resume async: error -22
> >
> > Reported-by: Lekensteyn <lekensteyn@gmail.com>
> > Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> Tested-by: Peter Wu <lekensteyn@gmail.com>
> 
> (for the real name policy, if you prefer "Lekensteyn", it's fine too)

Thanks for reporting and testing 
Tomas


