Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935214Ab0GPBex (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 21:34:53 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:61457 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935160Ab0GPBex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 21:34:53 -0400
Message-ID: <4C3FB632.6060105@kernel.org>
Date: Thu, 15 Jul 2010 18:30:26 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86,setup: add serial_console_port_base in boot_params
References: <4C3F8B46.7080809@kernel.org> <4C3FA3DB.4010507@zytor.com>
In-Reply-To: <4C3FA3DB.4010507@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4C3FB70C.013A,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2010 05:12 PM, H. Peter Anvin wrote:
> On 07/15/2010 03:27 PM, Yinghai Lu wrote:
>>
>> to save the early_serial_base.
>>
>> Also bootloader could fill that field, so setup code could reuse it.
>>
>> decompress code could reuse early serial console from setup code.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
> 
> What's the point with this over what we currently have?

extend serial console coverage to boot/compressed/misc.c

before this one, we have cover in boot/*.c only.

Thanks

Yinghai
