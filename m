Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab1EKU12 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 16:27:28 -0400
Received: from mail29.messagelabs.com ([216.82.249.147]:42133 "EHLO
	mail29.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103Ab1EKU11 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 16:27:27 -0400
X-VirusChecked: Checked
X-Env-Sender: Scott.Kilau@digi.com
X-Msg-Ref: server-8.tower-29.messagelabs.com!1305145646!87314591!1
X-StarScan-Version: 6.2.16; banners=-,-,-
X-Originating-IP: [66.77.174.13]
From: "Kilau, Scott" <Scott.Kilau@digi.com>
To: "'Greg KH'" <gregkh@suse.de>
CC: "'mreed10@us.ibm.com'" <mreed10@us.ibm.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'Alan Cox'" <alan@lxorguk.ukuu.org.uk>
Date: Wed, 11 May 2011 15:27:25 -0500
Subject: RE: [PATCH] 8250_pci: Add support for the Digi/IBM PCIe 2-port
 Adapter
Thread-Topic: [PATCH] 8250_pci: Add support for the Digi/IBM PCIe 2-port
 Adapter
Thread-Index: AcwQE7TPQV+091xQSI2PsiT04zQpiAABdGwQ
Message-ID: <A961E3870077E34C8FEF355D71BFDEAAC77C26CE4B@mtk-sms-exch01.digi.com>
References: <A961E3870077E34C8FEF355D71BFDEAAC77C11492C@mtk-sms-exch01.digi.com>
 <A961E3870077E34C8FEF355D71BFDEAAC77C26CE30@mtk-sms-exch01.digi.com>
 <20110511194318.GA26704@suse.de>
In-Reply-To: <20110511194318.GA26704@suse.de>
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

> From: Greg KH [mailto:gregkh@suse.de] 
> Sent: Wednesday, May 11, 2011 2:43 PM
> To: Kilau, Scott
> Cc: 'mreed10@us.ibm.com'; 'linux-kernel@vger.kernel.org'; 'Alan Cox'
> Subject: Re: [PATCH] 8250_pci: Add support for the Digi/IBM PCIe 2-port Adapter

> On Wed, May 11, 2011 at 02:28:07PM -0500, Kilau, Scott wrote:
> > --- linux-2.6.38.6-vanilla/include/linux/pci_ids.h	2011-04-21 16:34:46.000000000 -0500
> > +++ linux-2.6.38.6/include/linux/pci_ids.h	2011-04-27 14:56:30.000000000 -0500
> > @@ -1476,6 +1476,7 @@
> >  #define PCI_DEVICE_ID_NEO_2RJ45         0x00CA
> >  #define PCI_DEVICE_ID_NEO_2RJ45PRI      0x00CB
> >  #define PCIE_DEVICE_ID_NEO_4_IBM        0x00F4
> > +#define PCIE_DEVICE_ID_NEO_2_OX_IBM     0x00F6

> Please see the top of this file for why you shouldn't be adding new
> device ids into it.
> Third time's a charm?
> thanks,
> greg k-h

Sorry about that.
Should I just be putting them into 8250_pci.c directly instead?

I was conflicted as to where to put it, as I saw this comment in 8250_pci.c, before a list of device ids:
/* This should be in linux/pci_ids.h */

Thanks for your help!
Scott

