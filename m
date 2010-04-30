Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932539Ab0D3RCk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:02:40 -0400
Received: from smtp.nokia.com ([192.100.122.230]:60115 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757929Ab0D3RCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:02:08 -0400
Date: Fri, 30 Apr 2010 09:22:24 +0300
From: Heikki Krogerus <ext-heikki.krogerus@nokia.com>
To: ext Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the final tree (usb
 tree related)
Message-ID: <20100430062224.GB27724@esdhcp042221.research.nokia.com>
References: <20100430160555.d58bd9aa.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100430160555.d58bd9aa.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 30 Apr 2010 06:22:29.0890 (UTC) FILETIME=[82C98E20:01CAE82D]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Apr 30, 2010 at 08:05:55AM +0200, ext Stephen Rothwell wrote:
> Hi Greg,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> drivers/usb/otg/twl4030-usb.c: In function 'twl4030_usb_set_bits':
> drivers/usb/otg/twl4030-usb.c:238: error: implicit declaration of function 'ULPI_SET'
> drivers/usb/otg/twl4030-usb.c: In function 'twl4030_usb_clear_bits':
> drivers/usb/otg/twl4030-usb.c:244: error: implicit declaration of function 'ULPI_CLR'
> drivers/usb/otg/twl4030-usb.c: In function 'twl4030_usb_set_mode':
> drivers/usb/otg/twl4030-usb.c:303: error: 'ULPI_IFC_CTRL' undeclared (first use in this function)
> drivers/usb/otg/twl4030-usb.c:304: error: 'ULPI_IFC_CTRL_CARKITMODE' undeclared (first use in this function)
> drivers/usb/otg/twl4030-usb.c:306: error: 'ULPI_FUNC_CTRL' undeclared (first use in this function)
> drivers/usb/otg/twl4030-usb.c:307: error: 'ULPI_FUNC_CTRL_XCVRSEL_MASK' undeclared (first use in this function)
> drivers/usb/otg/twl4030-usb.c:308: error: 'ULPI_FUNC_CTRL_OPMODE_MASK' undeclared (first use in this function)
> 
> Caused by commit 57983872ff14cba23d6404a40c89e52063c94854 ("usb: otg:
> twl4030: use the global ULPI register definitions").  I have reverted
> that commit for today.

Already informed Greg that he needs the patch for the global ulpi
registers before this one.

-- 
heikki
