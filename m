Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357Ab1KBOSv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 10:18:51 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:58977 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755454Ab1KBOSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 10:18:49 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1111021132240.19054@axis700.grange>
References: <201110200012.43840.rjw@sisk.pl>
	<201110200015.06277.rjw@sisk.pl>
	<Pine.LNX.4.64.1111021132240.19054@axis700.grange>
Date: Wed, 2 Nov 2011 15:18:47 +0100
Message-ID: <CANqRtoS5KTws7rDoHkxrq8DP+js5xq=YF3zQG4MYmmjHEtv5NA@mail.gmail.com>
Subject: Re: [PATCH 3/3] ARM: mach-shmobile: sh7372 A4R support (v4)
From: Magnus Damm <magnus.damm@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 2, 2011 at 11:38 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Thu, 20 Oct 2011, Rafael J. Wysocki wrote:
>
>> From: Magnus Damm <damm@opensource.se>
>>
>> This change adds support for the sh7372 A4R power domain.
>
> This version still breaks I2C (#0) on mackerel. Tested with your
> sh7372-test branch of Oct 18th plus these four patches:
>
> 6b29305a PM / Domains: Add default power off governor function (v2)
> 3d578ae PM / Domains: Add device stop governor function (v2)
> 6c2cd02 ARM: mach-shmobile: sh7372 A4R support (v4)
> 9da11f4 ARM: mach-shmobile: sh7372 A3SP support (v4)

Exactly how does it break IIC0?

Does the same happen with the code base for upcoming 3.2-rc1 from
latest linux git?

Thanks,

/ magnus
