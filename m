Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980Ab2DMVsZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 17:48:25 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:59133 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426Ab2DMVsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 17:48:24 -0400
Date: Fri, 13 Apr 2012 18:48:17 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: Manoj Iyer <manoj.iyer@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Johan Hedberg <johan.hedberg@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH] Bluetooth: btusb: Add vendor specific ID (0a5c:21f4)
 BCM20702A0
Message-ID: <20120413214817.GB1680@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	Manoj Iyer <manoj.iyer@canonical.com>, linux-kernel@vger.kernel.org,
	linux-bluetooth@vger.kernel.org,
	Johan Hedberg <johan.hedberg@intel.com>,
	Marcel Holtmann <marcel@holtmann.org>
References: <1334169563-2948-1-git-send-email-manoj.iyer@canonical.com>
 <1334169563-2948-2-git-send-email-manoj.iyer@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334169563-2948-2-git-send-email-manoj.iyer@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Manoj,

* Manoj Iyer <manoj.iyer@canonical.com> [2012-04-11 13:39:23 -0500]:

> usb-devices:
> T:  Bus=01 Lev=02 Prnt=02 Port=03 Cnt=02 Dev#=  4 Spd=12  MxCh= 0
> D:  Ver= 2.00 Cls=ff(vend.) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
> P:  Vendor=0a5c ProdID=21f4 Rev=01.12
> S:  Manufacturer=Broadcom Corp
> S:  Product=BCM20702A0
> S:  SerialNumber=E4D53DF15584
> C:  #Ifs= 4 Cfg#= 1 Atr=e0 MxPwr=0mA
> I:  If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=01 Prot=01 Driver=btusb
> I:  If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=01 Prot=01 Driver=btusb
> I:  If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
> I:  If#= 3 Alt= 0 #EPs= 0 Cls=fe(app. ) Sub=01 Prot=01 Driver=(none)

You need to give the usb-devices for the non-working case. I know it
works but we need to document this right in the commit message.

	Gustavo
