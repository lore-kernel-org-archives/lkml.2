Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab1CJAbB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 19:31:01 -0500
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:57850 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752521Ab1CJAa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 19:30:59 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:X-X-Sender:To:cc:Subject:In-Reply-To:Message-ID:References:User-Agent:MIME-Version:Content-Type:X-Identified-User;
	b=SGL1LCByOAOL7ECpeL31u7J/+69BjoQ8XpyOxlsjdMQEOFudoTMsCORmahWGvlWP8fDjp+c6A0BKxf7Iz/R9atZ7nxwmVEQP9ScF2G9KzUZagFoWltgdSF4IkCHa8Vv8;
Date: Wed, 9 Mar 2011 16:30:56 -0800 (PST)
From: Randy Dunlap <rdunlap@xenotime.net>
X-X-Sender: rddunlap@chimera.site
To: Rob Landley <rlandley@parallels.com>
cc: Randy Dunlap <rdunlap@xenotime.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mariusz Kozlowski <mk@lab.zgora.pl>,
        LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org
Subject: Re: [PATCH] Remove obsolete Documentation/powerpc/00-INDEX entries
In-Reply-To: <4D77F465.2050208@parallels.com>
Message-ID: <alpine.LFD.2.00.1103091630450.2061@chimera.site>
References: <4D6095E3.2040103@parallels.com> <20110221185205.GA23284@mako-laptop> <4D62C43F.5040302@parallels.com> <20110221120303.48106f6c.rdunlap@xenotime.net> <4D62CC6B.9070408@parallels.com> <20110221125555.4a47424d.rdunlap@xenotime.net>
 <4D62DA51.8020108@parallels.com> <20110221134001.f8b66899.rdunlap@xenotime.net> <4D674B17.2050502@parallels.com> <20110225083728.0485cf4d.rdunlap@xenotime.net> <4D77F465.2050208@parallels.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 173.50.240.230 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 9 Mar 2011, Rob Landley wrote:

> On 02/25/2011 10:37 AM, Randy Dunlap wrote:
>>> Let me know if you want a replacement patch or a patch on top of this one.
>>
>> Thanks for catching that.
>> A replacement patch, please.
>
> Here you go:
>
> From: Rob Landley <rlandley@parallels.com>
>
> The device tree infrastructure is being genericized so its documentation moved
> out of the PowerPC directory.
>
> Signed-off-by: Rob Landley <rlandley@parallels.com>

applied, thanks.

> ---
>
> Documentation/devicetree/00-INDEX |   10 ++++++++++
> Documentation/powerpc/00-INDEX    |    4 ----
> 2 files changed, 10 insertions(+), 4 deletions(-)
>
> --- /dev/null	2011-02-13 16:59:19.073990002 -0600
> +++ b/Documentation/devicetree/00-INDEX	2011-02-21 14:47:12.911544002 -0600
> @@ -0,0 +1,10 @@
> +Documentation for device trees, a data structure by which bootloaders pass
> +hardware layout to Linux in a device-independent manner, simplifying hardware
> +probing.  This subsystem is maintained by Grant Likely
> +<grant.likely@secretlab.ca> and has a mailing list at
> +https://lists.ozlabs.org/listinfo/devicetree-discuss
> +
> +00-INDEX
> +	- this file
> +booting-without-of.txt
> +	- Booting Linux without Open Firmware, describes history and format of device trees.
> diff --git a/Documentation/powerpc/00-INDEX b/Documentation/powerpc/00-INDEX
> index e3960b8..5620fb5 100644
> --- a/Documentation/powerpc/00-INDEX
> +++ b/Documentation/powerpc/00-INDEX
> @@ -5,8 +5,6 @@ please mail me.
>
> 00-INDEX
> 	- this file
> -booting-without-of.txt
> -	- Booting the Linux/ppc kernel without Open Firmware
> cpu_features.txt
> 	- info on how we support a variety of CPUs with minimal compile-time
> 	options.
> @@ -16,8 +14,6 @@ hvcs.txt
> 	- IBM "Hypervisor Virtual Console Server" Installation Guide
> mpc52xx.txt
> 	- Linux 2.6.x on MPC52xx family
> -mpc52xx-device-tree-bindings.txt
> -	- MPC5200 Device Tree Bindings
> sound.txt
> 	- info on sound support under Linux/PPC
> zImage_layout.txt
>
>
>
