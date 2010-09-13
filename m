Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab0IMQOo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 12:14:44 -0400
Received: from mail.tpi.com ([70.99.223.143]:3378 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630Ab0IMQOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 12:14:43 -0400
Message-ID: <4C8E4DEA.2050406@canonical.com>
Date: Mon, 13 Sep 2010 10:14:34 -0600
From: Tim Gardner <tim.gardner@canonical.com>
Reply-To: tim.gardner@canonical.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100826 Thunderbird/3.0.7
MIME-Version: 1.0
To: "stable@kernel.org" <stable@kernel.org>
CC: Heiko Bauke <heiko.bauke@snafu.de>, linux-kernel@vger.kernel.org,
        romieu@fr.zoreil.com, timo.teras@iki.fi
Subject: Re: Realtek Ethernet drivers
References: <20100912210444.76ebeee6@tron.localdomain>	<20100912223724.GA15934@electric-eye.fr.zoreil.com> <20100913095912.74d7f0f1@tron.localdomain>
In-Reply-To: <20100913095912.74d7f0f1@tron.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2010 01:59 AM, Heiko Bauke wrote:
> Dear Francois,
>
> On Mon, 13 Sep 2010 00:37:25 +0200
> Francois Romieu<romieu@fr.zoreil.com>  wrote:
>
>> It's probably fixed with one of :
>> - 81a95f049962ec20a9aed888e676208b206f0f2e /
>> 024a07bacf8287a6ddfa83e9d5b951c5e8b4070e
>> - 908ba2bfd22253f26fa910cd855e4ccffb1467d0
>> - 78f1cd02457252e1ffbc6caa44a17424a45286b8
>>
>> [...]
>>> P.S. I am running 2.6.32-24-generic on a 32-bit Ubuntu 10.04.1 LTS
>>> box.
>>
>> Your 2.6.32-24-generic includes :
>> - 908ba2bfd22253f26fa910cd855e4ccffb1467d0
>> - 78f1cd02457252e1ffbc6caa44a17424a45286b8
>>
>> But it misses 81a95f049962ec20a9aed888e676208b206f0f2e and
>> 024a07bacf8287a6ddfa83e9d5b951c5e8b4070e
>
> I thank you for your reply. If there is time I will try a more recent
> kernel. (For the moment the Realtek drivers are fine for me.) I
> know how to (re-)compile distribution kernels and how to compile a
> vanilla kernel from kernel.org. However, I have no idea what the
> hex-codes you mentioned mean. Can you give me a hint?
>
>
> 	Regards,
>
> 	Heiko
>

If not already staged, please consider including these commits for 2.6.32.y:

024a07bacf8287a6ddfa83e9d5b951c5e8b4070e
81a95f049962ec20a9aed888e676208b206f0f2e

They are already included in 2.6.33.y and up, so its curious that they 
are not also included in 2.6.32.y as they do apply cleanly.

rtg
-- 
Tim Gardner tim.gardner@canonical.com
