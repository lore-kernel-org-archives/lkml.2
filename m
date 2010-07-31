Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742Ab0GaSWr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 14:22:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53306 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753792Ab0GaSWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 14:22:46 -0400
Message-ID: <4C5469AF.2010608@zytor.com>
Date: Sat, 31 Jul 2010 11:21:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86,setup: add serial_console_port_base in boot_params
References: <4C3F8B46.7080809@kernel.org> <20100731083409.GC5859@lenovo>
In-Reply-To: <20100731083409.GC5859@lenovo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2010 01:34 AM, Cyrill Gorcunov wrote:
> On Thu, Jul 15, 2010 at 03:27:18PM -0700, Yinghai Lu wrote:
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
> Hi Yinghai, sorry for delayed response. I like the idea much since it'll allow
> to log decompressor messages in case if someone would be changing exitsting code
> or developing new one, though this touches boot protocol so that grub/syslinux
> and friends will have to update their code as well which of course need some
> time.
> 

No, this is the internal part of the boot protocol, so it's not an issue.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

