Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101Ab2DPQMQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 12:12:16 -0400
Received: from antcom.de ([188.40.178.216]:45667 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454Ab2DPQMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 12:12:14 -0400
Message-ID: <4F8C44DC.7030702@antcom.de>
Date: Mon, 16 Apr 2012 18:12:12 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20120216 Icedove/8.0
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/3] USB: Add driver for NXP ISP1301 USB transceiver
References: <Pine.LNX.4.44L0.1204161201480.1408-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1204161201480.1408-100000@iolanthe.rowland.org>
X-Enigmail-Version: 1.3.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2012 06:02 PM, Alan Stern wrote:
>> Maybe one of (new):
>>
>>     drivers/usb/transceiver/
>>     drivers/usb/phy/
>>     drivers/usb/lowlevel/
>>
>> ?
>>
>> Otherwise, I will put it in drivers/usb/otg/ even of it doesn't look
>> better to me but the chip is advertised as "OTG transceiver". ;-)
> 
> I don't know.  Maybe Greg KH or Felipe Balbi will have a
> recommendation.  But any of these alternatives would be better than
> drivers/usb/misc/.

Since you and Greg-KH seem to be fine with the above, I'll pick
drivers/usb/phy/ for now.

Thanks for your fast responses,

Roland
