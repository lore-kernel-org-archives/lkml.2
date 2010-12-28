Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab0L1Jog (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 04:44:36 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:9671 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752169Ab0L1Joe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 04:44:34 -0500
Message-ID: <870E44F246C4486293DB2812E8DFD4BF@hacdom.okisemi.com>
From: "Toshiharu Okada" <toshiharu-linux@dsn.okisemi.com>
To: "Greg KH" <gregkh@suse.de>
Cc: "linux-usb" <linux-usb@vger.kernel.org>,
        "LKML" <linux-kernel@vger.kernel.org>, "Wang, Qi" <qi.wang@intel.com>,
        "Wang, Yong Y" <yong.y.wang@intel.com>,
        "Andrew" <andrew.chih.howe.khor@intel.com>,
        "Intel OTC" <joel.clark@intel.com>,
        "Ewe, Kok Howg" <kok.howg.ewe@intel.com>
References: <4D197433.2000800@dsn.okisemi.com> <20101228075205.GA8411@suse.de>
Subject: Re: [PATCH] usb: pch_udc: Fixed issue which does not work with g_serial
Date: Tue, 28 Dec 2010 18:44:20 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5931
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi greg k-h

I got to know that the PCH_UDC driver does not work normally when "Serial 
gadget" is used.
The receiving (EP0 OUT) data of control transmission had not received 
correctly.

This patch fixed this issue.
So the PCH_UDC driver can work normally with "Serial gadget".

Thanks

Best regards
Toshiharu Okada (OKI SEMICONDUCTOR)
----- Original Message ----- 
From: "Greg KH" <gregkh@suse.de>
To: "Toshiharu Okada" <toshiharu-linux@dsn.okisemi.com>
Cc: "linux-usb" <linux-usb@vger.kernel.org>; "LKML" 
<linux-kernel@vger.kernel.org>; "Wang, Qi" <qi.wang@intel.com>; "Wang, Yong 
Y" <yong.y.wang@intel.com>; "Andrew" <andrew.chih.howe.khor@intel.com>; 
"Intel OTC" <joel.clark@intel.com>; "Ewe, Kok Howg" <kok.howg.ewe@intel.com>
Sent: Tuesday, December 28, 2010 4:52 PM
Subject: Re: [PATCH] usb: pch_udc: Fixed issue which does not work with 
g_serial


On Tue, Dec 28, 2010 at 02:22:59PM +0900, Toshiharu Okada wrote:
> This patch fixes an issue which does not work with g_serial gadget.

What does that mean?  Please explain this better.

thanks,

greg k-h

