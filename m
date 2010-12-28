Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab0L1SkG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 13:40:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59571 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753985Ab0L1Sj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 13:39:56 -0500
Date: Tue, 28 Dec 2010 10:40:46 -0800
From: Greg KH <gregkh@suse.de>
To: Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>
Cc: linux-usb <linux-usb@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "Wang, Qi" <qi.wang@intel.com>, "Wang, Yong Y" <yong.y.wang@intel.com>,
        Andrew <andrew.chih.howe.khor@intel.com>,
        Intel OTC <joel.clark@intel.com>,
        "Ewe, Kok Howg" <kok.howg.ewe@intel.com>
Subject: Re: [PATCH] usb: pch_udc: Fixed issue which does not work with
 g_serial
Message-ID: <20101228184046.GB11830@suse.de>
References: <4D197433.2000800@dsn.okisemi.com>
 <20101228075205.GA8411@suse.de>
 <870E44F246C4486293DB2812E8DFD4BF@hacdom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <870E44F246C4486293DB2812E8DFD4BF@hacdom.okisemi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 28, 2010 at 06:44:20PM +0900, Toshiharu Okada wrote:
> Hi greg k-h
> 
> I got to know that the PCH_UDC driver does not work normally when "Serial 
> gadget" is used.
> The receiving (EP0 OUT) data of control transmission had not received 
> correctly.
> 
> This patch fixed this issue.
> So the PCH_UDC driver can work normally with "Serial gadget".

Great, please resend the patch with this information (remember, the more
the better) in the body of the email so it can be included in the
changelog comments.

thanks,

greg k-h
