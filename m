Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035Ab2LKU4g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 15:56:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35361 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753907Ab2LKU4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 15:56:33 -0500
Message-ID: <50C79DF4.3020300@zytor.com>
Date: Tue, 11 Dec 2012 12:56:20 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] Enable A20 using KBC for some MSI laptops to fix S3
 resume
References: <201210261056.44225.zary@gsystems.sk> <201212112129.13248.linux@rainbow-software.org> <50C7995E.7060301@zytor.com> <201212112150.38410.linux@rainbow-software.org>
In-Reply-To: <201212112150.38410.linux@rainbow-software.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2012 12:50 PM, Ondrej Zary wrote:
> On Tuesday 11 December 2012 21:36:46 H. Peter Anvin wrote:
>> On 12/11/2012 12:29 PM, Ondrej Zary wrote:
>>> Something like this? (It works.)
>>
>> Something like that.  We need to make sure we send the proper sequence,
>> though, or it might break some SMM firmware...
>
> Could you please create proper patch? You're the x86 expert (and I'm not).
>
> I've read that 0xd1 command with 0xdf data is often used to enable A20. But I
> don't know when this must be done or what else needs to be done for the SMM
> to not break.
>

You need to send an FF dummy command afterwards, that's all.


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

