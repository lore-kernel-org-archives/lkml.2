Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab1JJKav (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 06:30:51 -0400
Received: from mail.infrascan.de ([188.40.84.136]:41725 "EHLO infrascan.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753113Ab1JJKau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 06:30:50 -0400
Message-ID: <4E92C958.4020608@sensortherm.de>
Date: Mon, 10 Oct 2011 12:30:48 +0200
From: Klaus Schwarzkopf <schwarzkopf@sensortherm.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: balbi@ti.com
CC: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        sshtylyov@ru.mvista.com
Subject: Re: [PATCH v3] usb: add new usb gadget for ACM and mass storage
References: <1315506287-31368-1-git-send-email-schwarzkopf@sensortherm.de> <1318059850-3336-1-git-send-email-schwarzkopf@sensortherm.de> <20111010055010.GC31653@legolas.emea.dhcp.ti.com> <4E92ADBD.2010404@sensortherm.de> <20111010084947.GD6685@legolas.emea.dhcp.ti.com>
In-Reply-To: <20111010084947.GD6685@legolas.emea.dhcp.ti.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


>> Should bDeviceClass, bDeviceSubClass, and bDeviceProtocol have the
>> same value like in the file multi.c?
>>
>> 	.bDeviceClass =		USB_CLASS_MISC /* 0xEF */,
>> 	.bDeviceSubClass =	2,
>> 	.bDeviceProtocol =	1,

 From http://www.usb.org/developers/whitepapers/iadclasscode_r10.pdf:

This set of class codes is defined as the Multi-Interface Function
Device Class Codes.

So, this are the right settings.

Regards,

Klaus
