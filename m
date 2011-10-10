Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808Ab1JJQAS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 12:00:18 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:57971 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737Ab1JJQAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 12:00:16 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: balbi@ti.com, "Klaus Schwarzkopf" <schwarzkopf@sensortherm.de>
Cc: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        sshtylyov@ru.mvista.com
Subject: Re: [PATCH v3] usb: add new usb gadget for ACM and mass storage
References: <1315506287-31368-1-git-send-email-schwarzkopf@sensortherm.de>
 <1318059850-3336-1-git-send-email-schwarzkopf@sensortherm.de>
 <20111010055010.GC31653@legolas.emea.dhcp.ti.com>
 <4E92ADBD.2010404@sensortherm.de>
Date: Mon, 10 Oct 2011 18:00:11 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v2472lcp3l0zgt@mpn-glaptop>
In-Reply-To: <4E92ADBD.2010404@sensortherm.de>
User-Agent: Opera Mail/11.51 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Oct 2011 10:33:01 +0200, Klaus Schwarzkopf <schwarzkopf@sensortherm.de> wrote:
>> +static struct usb_device_descriptor device_desc = {
>> +	.bLength =		sizeof device_desc,
>> +	.bDescriptorType =	USB_DT_DEVICE,
>> +
>> +	.bcdUSB =		cpu_to_le16(0x0200),
>> +
>> +	.bDeviceClass =		USB_CLASS_COMM,
>> +	.bDeviceSubClass =	0,
>> +	.bDeviceProtocol =	0,

> Should bDeviceClass, bDeviceSubClass, and bDeviceProtocol have the same
> value like in the file multi.c?
>
> 	.bDeviceClass =		USB_CLASS_MISC /* 0xEF */,
> 	.bDeviceSubClass =	2,
> 	.bDeviceProtocol =	1,

IIRC, the reason multi.c has those is because Windows does not recognise
a multi-configuration device with zeros here.
