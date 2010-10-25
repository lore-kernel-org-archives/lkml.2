Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270Ab0JYJ0M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 05:26:12 -0400
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:40042
	"EHLO DB3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751975Ab0JYJ0L convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 05:26:11 -0400
X-Greylist: delayed 906 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Oct 2010 05:26:11 EDT
X-SpamScore: -30
X-BigFish: VPS-30(zz542N1432N148cM179dN9371Pzz1202hzzz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0LAU9I5-01-70P-02
X-M-MSG: 
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: XHCI: sleep inside atomic
Date: Mon, 25 Oct 2010 17:10:50 +0800
Message-ID: <2DEEA3AB13739D45A22ADDB5086AEA0B7AF518@sshaexmb1.amd.com>
In-Reply-To: <4CC29A0A.7070405@gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: XHCI: sleep inside atomic
Thread-Index: Actyit3ATevE8s75RiKBsN8k5efHwgBloEeg
References: <4CC29A0A.7070405@gmail.com>
From: "Xu, Andiry" <Andiry.Xu@amd.com>
To: Jiri Slaby <jirislaby@gmail.com>
CC: "Nguyen, Dong" <Dong.Nguyen@amd.com>, "Yang, Libin" <Libin.Yang@amd.com>,
        <sarah.a.sharp@linux.intel.com>, Greg KH <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 25 Oct 2010 09:10:54.0414 (UTC) FILETIME=[87150EE0:01CB7424]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm....You're right. Thanks for catching this, I'll submit a patch
later.

Thanks & Best regards,
Andiry
 
> -----Original Message-----
> From: Jiri Slaby [mailto:jirislaby@gmail.com]
> Sent: Saturday, October 23, 2010 4:17 PM
> To: Xu, Andiry
> Cc: Nguyen, Dong; Yang, Libin; sarah.a.sharp@linux.intel.com; Greg KH;
USB
> list; LKML
> Subject: XHCI: sleep inside atomic
> 
> Hi,
> 
> Stanse found that commit
>     USB: xHCI: PCI power management implementation
> added xhci_setup_msix->kmalloc(GFP_KERNEL) and request_irq inside
> xhci->lock spinlock. As these functions may sleep, this is
deadlockable.
> Could you fix that?
> 
> thanks,
> --
> js


