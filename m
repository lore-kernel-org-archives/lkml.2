Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934167Ab0KPKLh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 05:11:37 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34370 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934056Ab0KPKLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 05:11:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=kfWAlF/KRyv92oVUg383otVs9tx20uGeb7T0zBsGSRM9ryNSBRegfszNhydYk65Tox
         ebJDU+oz8ASfqc5MQIc8lTXx/L7l4jNX8hs4kyxAon7x2wO0rh/KIHUH87Q34pcv7hzc
         9lj/PZjZFY6brnUuLBkGGauFSQi7YFvMktmdU=
MIME-Version: 1.0
In-Reply-To: <20101116100406.GB12891@n2100.arm.linux.org.uk>
References: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com>
	<1289584840-18097-3-git-send-email-catalin.marinas@arm.com>
	<20101115233129.GG31421@n2100.arm.linux.org.uk>
	<AANLkTikrz+yM6idm-aij10vsKZMVSOBfZSdeEJbDRwiC@mail.gmail.com>
	<20101116100406.GB12891@n2100.arm.linux.org.uk>
Date: Tue, 16 Nov 2010 10:11:35 +0000
X-Google-Sender-Auth: Ov_ntjHjjfYcNbsZfyLwZkgav5Y
Message-ID: <AANLkTi=AGUs0nQPK0nx52m1XA8nx2sRmQcxicuG-Kd-D@mail.gmail.com>
Subject: Re: [PATCH v2 02/20] ARM: LPAE: Factor out 2-level page table
 definitions into separate files
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 November 2010 10:04, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Tue, Nov 16, 2010 at 09:14:52AM +0000, Catalin Marinas wrote:
>> > Of couse, I now have patches for this and my other points... will sort
>> > them out into a series in the next few days.
>>
>> Thanks.
>
> BTW, don't post another round of patches just because you've had _some_
> comments back - your v2 patches are still being looked through, your v3
> patches haven't even been looked at yet.

I'll wait for your patches on the PTE offset and than rebase mine on
top. It may be sometime next week as I already have a lot to do.

I posted the v3 patches just to clarify the issues around the 3/20
patch. The other patches are pretty much the same, so you can skip
this version and wait for v4.

-- 
Catalin
