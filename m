Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab0HVT5Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 15:57:16 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45762 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062Ab0HVT5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 15:57:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=AdG2xwG7f9DGBjd+TIZnOC8Ncqr9mrmF73tM+kRTbxaPHslpZA+Hzpw045VR4sXdp/
         6uJmMrk4z2Tpo76wZqw0Npu0CtV6YOqHxqdMJgRLy+IAMBJLTvLvYwEf7rBjWXpOc26M
         HbuBHc+B/NswP3eEmFL9Vjuf+n+PZtw9PFHjg=
Message-ID: <4C718115.8070103@garzik.org>
Date: Sun, 22 Aug 2010 15:57:09 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100720 Fedora/3.0.6-1.fc12 Thunderbird/3.0.6
MIME-Version: 1.0
To: Nicolas Jungers <nicolas@jungers.net>
CC: linux-kernel@vger.kernel.org,
        Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: possible esata regression in 2.6.35
References: <4C702070.5020809@jungers.net> <4C71808B.7070704@garzik.org>
In-Reply-To: <4C71808B.7070704@garzik.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2010 03:54 PM, Jeff Garzik wrote:
> On 08/21/2010 02:52 PM, Nicolas Jungers wrote:
>> My arm box doesn't succeed to use my esata port multiplier (addonics
>> sil3726 based). It was working well with 2.6.34.1 and 2.6.34.4 but not
>> with both 2.6.35.2 and 2.6.35.3. I haven't test other kernels.
>>
>> The kernels are from http://sheeva.with-linux.com/sheeva/ with for
>> example the following config
>> http://sheeva.with-linux.com/sheeva/2.6.35.3/sheeva-2.6.35.3.config
>>
>> The symptoms are in the console a loop on the esata links. Here is the
>> start of it:
>>
>> ata2: exception Emask 0x10 SAct 0x0 SErr 0x4010000 action 0xe frozen
>> ata2: edma_err_cause=00000010 pp_flags=00000000, dev connect
>> ata2: SError: { PHYRdyChg DevExch }
>> ata2: hard resetting link
>> ata2: SATA link up 3.0 Gbps (SStatus 123 SControl F300)
>> ata2.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
>
> Can you post or link to the entire dmesg?
>
> Notably, we need to see the probe messages to determine what SATA chip
> you are using... From the edma_err_cause config I'd guess sata_mv, but
> more info would be useful.

Nevermind, I see the reply (it got auto-sorted into the wrong folder 
locally).

