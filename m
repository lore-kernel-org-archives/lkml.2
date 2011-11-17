Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272Ab1KQMwE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 07:52:04 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45658 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab1KQMwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 07:52:02 -0500
Message-ID: <4EC50339.5000206@mvista.com>
Date: Thu, 17 Nov 2011 16:51:05 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Michal Nazarewicz <mina86@mina86.com>
CC: Felipe Balbi <balbi@ti.com>, Tonylijo <mail@tonylijo.in>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RESEND] usb : gadget : usbstring : fix style problems
References: <1321527544.2367.29.camel@debian1.ic> <op.v43ccxbe3l0zgt@mpn-glaptop>
In-Reply-To: <op.v43ccxbe3l0zgt@mpn-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 17-11-2011 16:44, Michal Nazarewicz wrote:

>> @@ -84,8 +90,8 @@ fail:
>> }
>> -/**
>> - * usb_gadget_get_string - fill out a string descriptor
>> +/*
>> + * usb_gadget_get_string - fill out a string descriptor

> Shouldn't that be usb_gadget_get_string() (ie. with parens)?

    Yes, that's kerneldoc format. Also, shouldn't have removed second * in /** 
-- that was there due to kerneldoc convention too.

WBR, Sergei
