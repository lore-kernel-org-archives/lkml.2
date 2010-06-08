Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108Ab0FHNRr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 09:17:47 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:56108 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802Ab0FHNRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 09:17:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=hJAgLRIceuiQeMMKWYX3iEQ/L+t2XRLIx/+gmfWTkHT2SqGy6YpwV2z5+XS0lcLSqj
         Ga7U7K4WGrjX8O/z5Py12cBhEnwJ2XJcvMd3eZSoh0Dbnbfm52bcwHg122gfi+r5i+7t
         ZX4nqx2AkmBVTsClNZbq6xVGe/qABD5nbm8yA=
MIME-Version: 1.0
In-Reply-To: <175392.50374.qm@web180311.mail.gq1.yahoo.com>
References: <9e21e4f5440d2a2fcfa11bca18e62c713317b330.1275906835.git.m.nazarewicz@samsung.com>
	<175392.50374.qm@web180311.mail.gq1.yahoo.com>
Date: Tue, 8 Jun 2010 21:17:42 +0800
Message-ID: <AANLkTikQu6jWqYWDFTWEusMUJKxnPMHDqVKdG5y3kR-P@mail.gmail.com>
Subject: Re: [PATCHv4 07/13] USB: gadget: g_ether: updated INF file
From: Xiaofan Chen <xiaofanc@gmail.com>
To: David Brownell <david-b@pacbell.net>
Cc: linux-usb@vger.kernel.org, Michal Nazarewicz <m.nazarewicz@samsung.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 8, 2010 at 8:57 PM, David Brownell <david-b@pacbell.net> wrote:
> --- On Mon, 6/7/10, Michal Nazarewicz <m.nazarewicz@samsung.com> wrote:
>> +; Copyright (c) Microsoft Corporation
>
> Erm, do we have the right to redistribute
> these changes, then?
>
>
> In principle, supporting more versions
> of MS-Windows is a good thing, but we need
> appropriate rights to do so, and it's not
> clear to me that we have those rights ..

http://msdn.microsoft.com/en-us/library/ff570620.aspx

I will think you can redistribute the file. After all, the template
is provided by Microsoft to an IHV (independent hardware vendor)
to use the Remote NDIS driver.

-- 
Xiaofan http://mcuee.blogspot.com
