Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941Ab2DPPkk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 11:40:40 -0400
Received: from antcom.de ([188.40.178.216]:42775 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754865Ab2DPPkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 11:40:39 -0400
Message-ID: <4F8C3D72.8040307@antcom.de>
Date: Mon, 16 Apr 2012 17:40:34 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20120216 Icedove/8.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, stern@rowland.harvard.edu,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/3] USB: Add driver for NXP ISP1301 USB transceiver
References: <1334582166-5485-1-git-send-email-stigge@antcom.de> <201204161414.14624.arnd@arndb.de>
In-Reply-To: <201204161414.14624.arnd@arndb.de>
X-Enigmail-Version: 1.3.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2012 04:14 PM, Arnd Bergmann wrote:
>> This driver needs to be probe()d before the respective USB driver using it. For
>> modules, this is handled via the module dependency. When linking statically, it
>> is done via linking order in the Makefile (misc/ before host/ and the gadget/).
> 
> You can easily avoid the link order restriction now by returning -EPROBE_DEFER
> from the probe function of the device that needs this one.

That's exactly what I was looking for! :-)

Same for the phandle idea.

Will include the resp. changes in the next update

Thanks,

Roland
