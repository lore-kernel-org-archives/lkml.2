Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab1AUPs3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 10:48:29 -0500
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:60265 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752070Ab1AUPs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 10:48:27 -0500
From: "Unrein, Jason" <Jason.Unrein@lsi.com>
To: "purpleidea@gmail.com" <purpleidea@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>
CC: scsi <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>
Date: Fri, 21 Jan 2011 08:47:23 -0700
Subject: RE: Status of the LSI 2108
Thread-Topic: Status of the LSI 2108
Thread-Index: Acu4/dPMqmBFQfx+QYmsdf884mWrhQAgvLng
Message-ID: <D41A5B864986B546A595D85C4701A9C001023A5A4E@cosmail03.lsi.com>
References: <1295411153.20086.81.camel@localhost>
	 <20110120153419.806d38e1.rdunlap@xenotime.net>
 <1295567826.20086.89.camel@localhost>
In-Reply-To: <1295567826.20086.89.camel@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p0LFmgog011836

The latest vanilla kernel should have support for all of our second generation sas HBAs (6gb/s capable).  If there are any problems you can always download an updated driver from the www.lsi.com website.  

The Supermicro ftp site you sent is actually for our counterpart in LSI, Megaraid.  Since they run a different firmware, they have a different driver in the kernel (megaraid_sas) where as ours are mptlinux (Gen1, 3.0gb/s), mpt2sas (Gen2), mpt2sasbtm (Gen2 but for older 2.6 kernels).  We both use the same chip so Supermicro might be making it a little confusing.  You might see if they reference the chip as a Megaraid chip in any way or if it is always an LSI chip. It is possible to run it in both modes if all the hardware components are there.

It would probably be best to email Supermicro and get the details from them about the chip to confirm what you need.

-----Original Message-----
From: James Shubin [mailto:purpleidea@gmail.com] 
Sent: Thursday, January 20, 2011 5:57 PM
To: Randy Dunlap
Cc: scsi; linux-kernel@vger.kernel.org; DL-MPT Fusion Linux
Subject: Re: Status of the LSI 2108

Thanks Randy for sending me in the right direction.
Hello linux-scsi and LSI. Any thoughts to the below question would be
much appreciated!

James


On Thu, 2011-01-20 at 15:34 -0800, Randy Dunlap wrote:
> On Tue, 18 Jan 2011 23:25:53 -0500 James Shubin wrote:
> 
> > Hi,
> > 
> > I've been trying to find out if the LSI 2108 is fully supported in the
> > vanilla kernel, and any thoughts as to the quality/robustness.
> > 
> > This seems to be the correct source:
> > ftp://ftp.supermicro.nl/driver/SAS/LSI/2108/Driver/Linux/v04.31/
> > however I'm not sure at all if it's maintained, or what. I would
> > outright test this myself, however I haven't bought the servers yet
> > 
> > Thanks for your help,
> > Please cc-me on replies.
> 
> Hi,
> 
> Probably better to ask on the linux-scsi mailing list [added].
> Also added the lsi.com email address.
> 
> 
> drivers/scsi/mpt2sas/mpt2sas_scsih.c contains this:
> 
> 	/* Liberator ~ 2108 */
> 	{ MPI2_MFGPAGE_VENDORID_LSI, MPI2_MFGPAGE_DEVID_SAS2108_1,
> 		PCI_ANY_ID, PCI_ANY_ID },
> 	{ MPI2_MFGPAGE_VENDORID_LSI, MPI2_MFGPAGE_DEVID_SAS2108_2,
> 		PCI_ANY_ID, PCI_ANY_ID },
> 	{ MPI2_MFGPAGE_VENDORID_LSI, MPI2_MFGPAGE_DEVID_SAS2108_3,
> 		PCI_ANY_ID, PCI_ANY_ID },
> 
> so it looks like there is at least some basic support for the 2108.
> 
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
