Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746Ab0G0Il7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 04:41:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:42618 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753905Ab0G0Il5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 04:41:57 -0400
Message-ID: <4C4E9BC0.6060805@kernel.org>
Date: Tue, 27 Jul 2010 10:41:36 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Yuhong Bao <yuhongbao_386@hotmail.com>, jeff@garzik.org,
        ben.collins@ubuntu.com, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, hmh@debian.org
Subject: Re: support for drives larger than 2TiB
References: <4C4AB952.9030705@kernel.org> <SNT125-W4469FAC3FE110BB4882949C3A40@phx.gbl> <4C4BEF61.5010203@kernel.org> <4C4BF0D2.1070503@zytor.com> <4C4BF3C2.1020009@kernel.org> <4C4C87EF.5080605@zytor.com>
In-Reply-To: <4C4C87EF.5080605@zytor.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 27 Jul 2010 08:41:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 07/25/2010 08:52 PM, H. Peter Anvin wrote:
> If you can set up the disk with GPT then just set up a bootable
> partition beyond the 2 TiB mark and install Syslinux 4 on it.  (Note:
> there is a bug in current versions of gdisk: attribute 2 is the legacy
> BIOS bootable attribute, but the author got the bit order wrong and so
> you have to set "attribute 61".  parted doesn't support the legacy BIOS
> bootable attribute yet.)
>
> If you don't want tomodify the contents of the disk then it can still be
> tested, but I don't have a ready-made test for you.

The disk doesn't contain any data.  I'll try it with several different
motherboards and report back.

Thanks.

-- 
tejun
