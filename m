Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268Ab1EITiP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 15:38:15 -0400
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:54600
	"EHLO DB3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754198Ab1EITiL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 15:38:11 -0400
X-SpamScore: -10
X-BigFish: VPS-10(zz1447Rzz1202hzz8275bhz2fh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:avexcashub1.qlogic.com;RD:avexcashub1.qlogic.com;EFVD:NLI
From: Mike Marciniszyn <mike.marciniszyn@qlogic.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
CC: "roland@kernel.org" <roland@kernel.org>,
        "sean.hefty@intel.com" <sean.hefty@intel.com>,
        "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Mon, 9 May 2011 12:38:05 -0700
Subject: RE: [PATCH 1/2] ipath: use pci_dev->revision, again
Thread-Topic: [PATCH 1/2] ipath: use pci_dev->revision, again
Thread-Index: AcwM3gP8ssX3mQj+Toeo0j3rWNob/ABofmaw
Message-ID: <35AAF1E4A771E142979F27B51793A4888838BCBDB7@AVEXMB1.qlogic.org>
References: <201105072139.37992.sshtylyov@ru.mvista.com>
In-Reply-To: <201105072139.37992.sshtylyov@ru.mvista.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: qlogic.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Commit 44c10138fd4bbc4b6d6bff0873c24902f2a9da65 (PCI: Change all drivers to use
> pci_device->revision) already converted this driver to using the 'revision'
> field of 'struct pci_dev' but commit bb9171448deb1f7ece27674e2e431e4f267fd453
> (IB/ipath: Misc changes to prepare for IB7220 introduction) later reverted that
> change for some strange reason. Now restore the change...

Thanks for the patch.

ipath: use pci_dev->revision, again

Acked-by: Mike Marciniszyn <mike.marciniszyn@qlogic.com>

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

