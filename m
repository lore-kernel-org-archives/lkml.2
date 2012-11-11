Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531Ab2KKXno (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 18:43:44 -0500
Received: from snt0-omc3-s10.snt0.hotmail.com ([65.55.90.149]:52282 "EHLO
	snt0-omc3-s10.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751179Ab2KKXnm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 18:43:42 -0500
X-Greylist: delayed 405 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Nov 2012 18:43:42 EST
Message-ID: <SNT002-W1374257CE2BDB85F6026D7DC36E0@phx.gbl>
X-Originating-IP: [142.58.21.131]
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Girish Verma <girish@circuitsutra.com>
CC: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: RE: [PATCH] USB: XHCI: xhci-ring: Remove unused dma address
 calculation in inc_enq and inc_deq function
Date: Sun, 11 Nov 2012 15:36:36 -0800
Importance: Normal
In-Reply-To: <20120906182856.GC4618@xanatos>
References: <1336922942.3945.12.camel@cst-girish-laptop>
 <1346946453.5012.1.camel@cst-girish-laptop>,<20120906182856.GC4618@xanatos>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 11 Nov 2012 23:36:36.0349 (UTC) FILETIME=[63E05AD0:01CDC065]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It looks like your mail client attempted to line wrap it. You might
> want to use mutt, thunderbird, or maybe even the plain text gmail
> interface to resend this.
If anyone is using Outlook, see this:
https://lkml.org/lkml/2011/1/25/587

Yuhong Bao 		 	   		  