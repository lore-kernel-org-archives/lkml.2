Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab2LDUPe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 15:15:34 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:16022 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab2LDUPc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 15:15:32 -0500
From: "Ortiz, Lance E" <lance.oritz@hp.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: "bhelgaas@google.com" <bhelgaas@google.com>,
        "lance_ortiz@hotmail.com" <lance_ortiz@hotmail.com>,
        "jiang.liu@huawei.com" <jiang.liu@huawei.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v6 2/3] aerdrv: Enhanced AER logging
Thread-Topic: [PATCH v6 2/3] aerdrv: Enhanced AER logging
Thread-Index: AQHN0k8aVa3PxcUcQEiyZTOCi6RVGJgJEWMg
Date: Tue, 4 Dec 2012 20:14:10 +0000
Message-ID: <A961433CDFF2F640A2866803152E61F9516EEACD@G4W3218.americas.hpqcorp.net>
References: <20121204170429.31397.50068.stgit@grignak.americas.hpqcorp.net>
	<20121204170436.31397.40857.stgit@grignak.americas.hpqcorp.net>
 <20121204164151.66b9bb37@redhat.com>
In-Reply-To: <20121204164151.66b9bb37@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.25]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +	if (!dev) {
> > +		pr_info("PCI AER Cannot get PCI device
> %04x:%02x:%02x.%d\n",
> > +			pcie->device_id.segment, pcie->device_id.bus,
> > +			pcie->device_id.slot, pcie->device_id.function);
> 
> Hmm... please correct if I'm wrong, but an error happened at PCI, and
> also a
> kernel bug that prevented it to get the proper PCI device...
> 
> IMHO, the message here should be stronger, and likely printed via
> pr_err().
> 

Mauro,

I modeled this message after other places in the kernel where this function failed.  So I figured it would be safe to be consistent there.  I agree though that it should be pr_err().  I can make that change.
