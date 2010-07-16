Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759494Ab0GPXyq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 19:54:46 -0400
Received: from mail.gmx.net ([213.165.64.20]:49554 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754753Ab0GPXyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 19:54:45 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/SH7hfPvDSjw3lb9MENlQTCX6qLtrIIfm5TyRf25
	mBYl9cJT7c+5ee
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 12/25] char: Convert pci_table entries to PCI_VDEVICE (if PCI_ANY_ID is used)
Date: Sat, 17 Jul 2010 01:54:52 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34; KDE/4.3.5; x86_64; ; )
Cc: Kernel Janitors <kernel-janitors@vger.kernel.org>,
        "Digi International, Inc" <Eng.Linux@digi.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Tejun Heo <tj@kernel.org>,
        Jiri Kosina <jkosina@suse.cz>, Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org
References: <201007152052.38060.PeterHuewe@gmx.de> <201007152307.35062.PeterHuewe@gmx.de> <20100716042845.GA28607@suse.de>
In-Reply-To: <20100716042845.GA28607@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007170154.52461.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 16 Juli 2010 06:28:45 schrieb Greg KH:
> > Maybe there should be a version of PCI_DEVICE that addresses this issue?
> > But I have to admit, something like:
> > { PCI_DEVICE_DD(PCI_VENDOR_ID_DIGI, PCI_DEVICE_XR), brd_xrj },
> > doesn't look that much better.
> 
> You can do:
> 	{ PCI_DEVICE_TABLE(PCI_VENDOR_ID_DIGI, PCI_DEVICE_XR), brd_xrj },
> just fine today, so do that if you want to.


Hi Greg,

unfortunately I can't find the definition of this macro - can you perhaps 
pinpoint me to it? And maybe an example in the kernel?

Thanks,
Peter
