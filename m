Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab1CJHAp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 02:00:45 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59336 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797Ab1CJHAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 02:00:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=nN7L8EzLV0sd4ANNqSVvhulKBCiqW0JT1k6O/p/KRDlBlDfbdFs7LoWORNdSRbp1Rc
         P0r+SiAEUENhhwvOvNYlopHJBXq/C5bs5hnEpET3WTvVDInXy9RTIjKVZD02a4+2oayk
         EFSNjYQmRo4uG7GimCa7qp8hlRBRHmoVeIJ+0=
Message-ID: <4D787714.6060405@gmail.com>
Date: Thu, 10 Mar 2011 09:00:36 +0200
From: Nikolai Kondrashov <spbnick@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20101227 Icedove/3.0.11
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Matthew Garrett <mjg@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] Platform: add Samsung Laptop platform driver
References: <20110209224006.GA11202@kroah.com> <AANLkTikrr6Gu_qoq73ASC95E0HQC1p6KzDPLxo=J_rva@mail.gmail.com> <20110225210334.GB16860@kroah.com> <4D6823DD.6040809@gmail.com> <20110225225055.GA5931@kroah.com>
In-Reply-To: <20110225225055.GA5931@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On 02/26/2011 12:50 AM, Greg KH wrote:
> On Sat, Feb 26, 2011 at 12:49:17AM +0300, Nikolai Kondrashov wrote:
>> On 02/26/2011 12:03 AM, Greg KH wrote:
>>> This should work, as we support the N150/N210/N220 versions.
>>>
>>> Can you provide the output of:
>>> 	grep ./sys/class/dmi/id/*
>>>
>>> so I can verify this?
>> Sure. Please find it attached. It is taken on a stock Debian kernel, without
>> your patch.
>>
>> Could I have configured the kernel incorrectly?
>
> Maybe, that's odd.
>
> Care to try the version of the patch below to see if that works better
> for you or not?
Thank you. The result is the same: ENODEV without "force" and "This computer
doesn't support SABI" and EINVAL with "force".

Sorry for the delay - I'm in the process of chaning my job as well as the
country of living now.

Sincerely,
Nick
