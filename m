Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435Ab0DGXqh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 19:46:37 -0400
Received: from mail-yw0-f172.google.com ([209.85.211.172]:38059 "EHLO
	mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756144Ab0DGXqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 19:46:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=YYwFAEwdOwD5EmbkHI1keUhCkRMzmE7DpVfX3S1Hnm0zxFvAc5bU7ugdHLATDLuUlP
         T/zGt7ND2sPiKs9673W3Exy19MMQ2winocyM6hlNX/JZGvq0bLcL1MX+UhKe+fKMED4I
         M/h88gUcgOpwgNYY4ijzrJk+zDdicoFIEYsZ8=
Message-ID: <4BBD1957.90502@gmail.com>
Date: Wed, 07 Apr 2010 17:46:31 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Mark Knecht <markknecht@gmail.com>
CC: Clemens Ladisch <clemens@ladisch.de>,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: Failed to initialize MSI interrupts && ioremap reserve_memtype
  failed -22
References: <x2w5bdc1c8b1004051355o3f803c75t2515ef46320e00bd@mail.gmail.com>	 <4BBC9CA1.5080102@ladisch.de> <m2l5bdc1c8b1004070857r823821ack6cc99354db73eaa0@mail.gmail.com>
In-Reply-To: <m2l5bdc1c8b1004070857r823821ack6cc99354db73eaa0@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2010 09:57 AM, Mark Knecht wrote:
> On Wed, Apr 7, 2010 at 7:54 AM, Clemens Ladisch<clemens@ladisch.de>  wrote:
>> Mark Knecht wrote:
>>>     New hardware and I haven't seen these messages before so I thought
>>> I'd post them.
>>
>> Both might be harmless.  Please show the entire boot log.
>>
>>
>> Regards,
>> Clemens
>>
>
> Hopefully you mean the contents of dmesg. If it's something else let me know.
>
> If the mail server deletes the text file attachment I'll reply again
> pasting the text in by hand.

Looks like the start of the log was truncated. Can you check if your 
distro writes the bootup kernel output somewhere (like /var/log/dmesg)?
