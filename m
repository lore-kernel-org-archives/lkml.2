Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661Ab0I2DCv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 23:02:51 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51082 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab0I2DCu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 23:02:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=A+HX/ADf5SociXHXOwcbgQp5pLnfgP/5XOfvvu0co6FO4If6cQk5Bn1jo5pqDyxnTe
         K/jpuTyhEzroqno/5qsNqX8Ozoa4gV/Qw1626uFEa3SqOszXDVjjZA7eKMim44FktT/u
         g2brAEaLugRrPyLVxN4b7hCdc+5mtwshv/G8M=
MIME-Version: 1.0
In-Reply-To: <1285729189.1866.155.camel@Joe-Laptop>
References: <20100929025206.GA8002@july>
	<1285729189.1866.155.camel@Joe-Laptop>
Date: Wed, 29 Sep 2010 12:02:48 +0900
X-Google-Sender-Auth: bSzKO59vEhV3fUuM8fCq_qNpH1M
Message-ID: <AANLkTimFn1kqWe3mJrfCvBus_T5+KWx1hzw7mDxBwqdu@mail.gmail.com>
Subject: Re: [PATCH 2/2] MAINTAINERS: Add Samsung S5P FIMC maintainers
From: Kyungmin Park <kmpark@infradead.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, rmk@arm.linux.org.uk, kgene.kim@samsung.com,
        m.szyprowski@samsung.com, pawel@osciak.com, t.fujak@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 11:59 AM, Joe Perches <joe@perches.com> wrote:
> On Wed, 2010-09-29 at 11:52 +0900, Kyungmin Park wrote:
>> From: Kyungmin Park <kyungmin.park@samsung.com>
>> diff --git a/MAINTAINERS b/MAINTAINERS
> []
>> @@ -977,6 +977,17 @@ L:       linux-arm-kernel@lists.infradead.org
>>  S:   Maintained
>>  F:   arch/arm/mach-s5pv310/mach-universal_c210.c
>>
>> +ARM:S5P FIMC SUPPORT
>
> A colon not a slash just to be different
> or that a Samsung thing?

Right, it's typo. It should be a slash.
Do you think ARM/SAMSUNG S5P is better?

Thank you,
Kyungmin Park
>
>>  ARM/SHMOBILE ARM ARCHITECTURE
>>  M:   Paul Mundt <lethal@linux-sh.org>
>>  M:   Magnus Damm <magnus.damm@gmail.com>
>
>
>
>
