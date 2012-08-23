Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359Ab2HWQqY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 12:46:24 -0400
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:35484 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751767Ab2HWQqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 12:46:19 -0400
MIME-Version: 1.0
In-Reply-To: <50365CC1.3080402@xenotime.net>
References: <20120823152203.34297f3bc5fbb43d10653fcc@canb.auug.org.au>
	<50365CC1.3080402@xenotime.net>
Date: Thu, 23 Aug 2012 22:16:17 +0530
Message-ID: <CAAe_U6+tDERZK8nBdEpOWuBaZNpW8YVc2vYQ+Ju1tACjTVk8ow@mail.gmail.com>
Subject: Re: linux-next: Tree for Aug 23 (drivers/bus/omap-ocp2scp.c)
From: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 10:09 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On 08/22/2012 10:22 PM, Stephen Rothwell wrote:
>
>> Hi all,
>>
>> Changes since 20120822:
>>
>
>
> on i386:
>
>   CC [M]  drivers/bus/omap-ocp2scp.o
> drivers/bus/omap-ocp2scp.c:70:1: error: '__mod_of_device_table' aliased to undefined symbol 'omap_usb2_id_table'

Sorry. Will send the correct version to be merged.

-Kishon
