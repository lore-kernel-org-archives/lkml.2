Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab0K0MXt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 07:23:49 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49932 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab0K0MXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 07:23:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Ogh5JHham3QPAe4b5D0oXelMQpY2MdQtWUcoxLMFFscdQCdfcf4y9NlzAw+T1aulKX
         n2JFGSdGnlj3WoF92HBYwixoLoN1KSnGmMs/g5SRh/z0MyazAPj74pam8iIu5IWqSntf
         yjNiG5dbOffGTr7LBYzeyn94HAe6C4pFPTFF4=
Message-ID: <4CF0F849.9090209@gmail.com>
Date: Sat, 27 Nov 2010 09:23:37 -0300
From: thiago <thsalex@gmail.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Oliver Neukum <oneukum@suse.de>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Problem with usb card
References: <4CEBBF07.9090607@gmail.com> <201011231535.55886.oneukum@suse.de>
In-Reply-To: <201011231535.55886.oneukum@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do you know how to solve the problem?

Oliver Neukum wrote:
> Am Dienstag, 23. November 2010, 14:17:59 schrieb thiago:
>   
>> [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.25-custom #1
>> [    0.000000]  [<c0121207>] warn_on_slowpath+0x40/0x4f
>> [    0.000000]  [<c02b1dfd>] _spin_unlock_irqrestore+0xd/0x10
>> [    0.000000]  [<c0121897>] release_console_sem+0x186/0x19f
>> [    0.000000]  [<c0121cc0>] vprintk+0x2d0/0x2fe
>> [    0.000000]  [<c0372eb0>] mtrr_trim_uncached_memory+0x1a7/0x1ac
>> [    0.000000]  [<c0370f64>] setup_arch+0x23d/0x418
>> [    0.000000]  [<c036b5c6>] start_kernel+0x70/0x33a
>> [    0.000000]  =======================
>> [    0.000000] ---[ end trace ca143223eefdc828 ]---
>>
>> After that message error, i lost the partition table of the my sdcard
>> and all work is lost too
>>
>>     
>
> This does look like an mtrr problem, not a USB problem.
>
> 	Regards
> 		Oliver
>
>   


-- 
Thiago Silveira Alexandre
LPI I Certified
Security Enginner
Intechne Tecnologia da Informação
(98) 3311 6200
(98) 3311 6219
(98) 8132 1020

