Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964967Ab2DLOQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 10:16:00 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53181 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933556Ab2DLOP6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 10:15:58 -0400
From: "Mohammed, Afzal" <afzal@ti.com>
To: Greg KH <greg@kroah.com>
CC: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        Paul Walmsley <paul@pwsan.com>, "V, Aneesh" <aneesh@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "mgreer@animalcreek.com" <mgreer@animalcreek.com>,
        "msalter@redhat.com" <msalter@redhat.com>
Subject: RE: [PATCH v4 0/7] Add TI EMIF SDRAM controller driver
Thread-Topic: [PATCH v4 0/7] Add TI EMIF SDRAM controller driver
Thread-Index: AQHNA78a9lhevdYvxk2HV7vF+jKLg5aWSLeAgAAEfgCAAD9ygIAAQRWAgACIIFD//4iqAIAAhkPw
Date: Thu, 12 Apr 2012 14:15:17 +0000
Message-ID: <C8443D0743D26F4388EA172BF4E2A7A93E95B4EB@DQHE04.ent.ti.com>
References: <1331934707-29487-1-git-send-email-aneesh@ti.com>
 <alpine.DEB.2.00.1204112042070.29473@utopia.booyaka.com>
 <20120412030044.GA26236@kroah.com> <4F867A95.9030104@ti.com>
 <20120412131045.GB31384@kroah.com>
 <C8443D0743D26F4388EA172BF4E2A7A93E95947E@DQHE04.ent.ti.com>
 <20120412141050.GA31968@kroah.com>
In-Reply-To: <20120412141050.GA31968@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Thu, Apr 12, 2012 at 19:40:50, Greg KH wrote:
> > There is another memory controller used in a few TI SoCs,
> > namely GPMC [1], do you prefer having it too there.
> 
> Sure, why not?

Thanks a lot, we were struggling to find a suitable location for the driver.

Regards
Afzal 
