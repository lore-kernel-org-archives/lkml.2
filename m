Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241Ab2HGD14 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 23:27:56 -0400
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:56807
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757182Ab2HGD1x convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 23:27:53 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -8
X-BigFish: VS-8(zz98dI9371I542M1432I4015Izz1202hzz8275bhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah107ahbe9i)
From: Liu Qiang-B32616 <B32616@freescale.com>
To: Phillips Kim-R1AAHA <R1AAHA@freescale.com>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "herbert@gondor.hengli.com.au" <herbert@gondor.hengli.com.au>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dan.j.williams@gmail.com" <dan.j.williams@gmail.com>,
        Li Yang-R58472 <r58472@freescale.com>
Subject: RE: [PATCH v6 0/8] Raid: enable talitos xor offload for improving
 performance
Thread-Topic: [PATCH v6 0/8] Raid: enable talitos xor offload for improving
 performance
Thread-Index: AQHNc7us2FJzu4cYy0q8H18QR88+rJdN5hkA///K8IA=
Date: Tue, 7 Aug 2012 03:27:49 +0000
Message-ID: <BCB48C05FCE8BC4D9E61E841ECBE6DB70E108F@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1344247815-1104-1-git-send-email-qiang.liu@freescale.com>
 <20120806203506.bcf31cc63a2d1f55a9695f13@freescale.com>
In-Reply-To: <20120806203506.bcf31cc63a2d1f55a9695f13@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.208.94]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Phillips Kim-R1AAHA
> Sent: Tuesday, August 07, 2012 9:35 AM
> To: Liu Qiang-B32616
> Cc: linux-crypto@vger.kernel.org; vinod.koul@intel.com;
> dan.j.williams@intel.com; herbert@gondor.hengli.com.au; arnd@arndb.de;
> gregkh@linuxfoundation.org; linuxppc-dev@lists.ozlabs.org; linux-
> kernel@vger.kernel.org; dan.j.williams@gmail.com; Li Yang-R58472
> Subject: Re: [PATCH v6 0/8] Raid: enable talitos xor offload for
> improving performance
> 
> On Mon, 6 Aug 2012 18:10:15 +0800
> <qiang.liu@freescale.com> wrote:
> 
> > Changes in v6:
> > 	- swap the order of original patch 3/6 and 4/6;
> > 	- merge Ira's patch to reduce the size of original patch;
> > 	- merge Ira's patch of carma in 8/8;
> > 	- update documents and descriptions according to Ira's advice;
> 
> fwiw, I gave v5 a test-drive, setting up a RAID5 array on ramdisks [1],
> and this patchseries, along with FSL_DMA && NET_DMA set seems to be
> holding water, so this series gets my:
> 
> Tested-by: Kim Phillips <kim.phillips@freescale.com>
Thanks, Kim. I will add this line in v7:)

> 
> Thanks,
> 
> Kim
> 
> [1] mdadm --create --verbose --force /dev/md0 --level=raid5 --raid-
> devices=4 /dev/ram[0123]

