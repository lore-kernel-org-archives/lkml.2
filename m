Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab2K0OYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 09:24:15 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53579 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab2K0OYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 09:24:13 -0500
MIME-Version: 1.0
In-Reply-To: <20121127125805.GB31484@netboy.at.omicron.at>
References: <201211270941.52055.tim01@iss.tu-darmstadt.de> <20121127125805.GB31484@netboy.at.omicron.at>
From: Yegor Yefremov <yegorslists@googlemail.com>
Date: Tue, 27 Nov 2012 15:23:51 +0100
Message-ID: <CAGm1_kswo5mp75G8z8_PvnvXp2nfZQ5WnMv4gQsOoj1U_7c1hw@mail.gmail.com>
Subject: Re: am33xx beaglebone mainline status?
To: Richard Cochran <richardcochran@gmail.com>
Cc: Tim Sander <tim01@iss.tu-darmstadt.de>,
        kernel list <linux-kernel@vger.kernel.org>, linux@arm.linux.org.uk,
        linux-rt-users@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 1:58 PM, Richard Cochran
<richardcochran@gmail.com> wrote:
> On Tue, Nov 27, 2012 at 09:41:51AM +0100, Tim Sander wrote:
>> Hi
>>
>> I have been trying to get the 3.7-rc6 kernel to compile for a beaglebone board
>> with device tree but it seems there are still bits missing. Especially it
>> seems as if the sd card reader and network is not working properly?
>
> The CPSW network driver is working in net-next, and so it will be
> working in v3.8. Don't know about SD, since I only boot with a ramfs.

MMC support is still not there. There patches on the linux-omap
mailing list, AFAIK they are in review process.

How do you load your rootfs: embedded into kernel or separately?

Do you know if frame buffer is functioning in main line?

Yegor
