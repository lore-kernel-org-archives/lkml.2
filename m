Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161Ab2AYGXI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 01:23:08 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14866 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833Ab2AYGXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 01:23:05 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 24 Jan 2012 22:23:02 -0800
Message-ID: <4F1F9FA1.4000000@nvidia.com>
Date: Wed, 25 Jan 2012 11:52:25 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "lrg@ti.com" <lrg@ti.com>, "jedu@slimlogic.co.uk" <jedu@slimlogic.co.uk>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V1] regulator: tps65910: Sleep control through external
 inputs
References: <1327395919-32378-1-git-send-email-ldewangan@nvidia.com> <20120124115855.GC14888@opensource.wolfsonmicro.com> <4F1EA1E8.90104@nvidia.com> <20120124122411.GB31839@opensource.wolfsonmicro.com> <4F1EA608.3020204@nvidia.com> <20120124212144.GG1135@opensource.wolfsonmicro.com>
In-Reply-To: <20120124212144.GG1135@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 January 2012 02:51 AM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Tue, Jan 24, 2012 at 06:07:28PM +0530, Laxman Dewangan wrote:
>
>> E.g. If cpu power is in VDDCTRL rail and if DVFS mechanism of SOC
>> wants that cpu rails to be ON, it will make the control signal
>> active and if it wants to disable the rail then it will deactivate
>> it.
>> The toggling of the control lines depends on how the power
>> management controller is designed for a given SOC and how it
>> manages.
> Hrm, right.  This isn't something that the regulator API usually deals
> with - normally we just deal with things that Linux owns and assume that
> if the hardware is wired up for something else to own the regulator it
> will deal with that completely including the configuration.  If we do
> need to do something here we need to make sure that the normal regulator
> code doesn't try to do anything clever with the regulator which messes
> up the other device.  But I guess this doesn't really have a problem
> with that, someone can always add a further patch optionally specifying
> GPIOs which won't conflict with this approach.
Thanks, I will send patch v2 having all fixes which is discuss in patch V1.
> * Unknown Key
> * 0x6E30FDDD

