Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab1FITuI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 15:50:08 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:48366 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755141Ab1FITuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 15:50:03 -0400
Message-ID: <4DF123AA.6070402@oracle.com>
Date: Thu, 09 Jun 2011 12:48:58 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Timur Tabi <timur@freescale.com>
CC: alan@lxorguk.ukuu.org.uk, arnd@arndb.de, kumar.gala@freescale.com,
        benh@kernel.crashing.org, greg@kroah.com, akpm@kernel.org,
        cmetcalf@tilera.com, konrad.wilk@oracle.com, dsaxena@linaro.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-console@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 7/7] [v5] drivers/virt: introduce Freescale hypervisor
 management driver
References: <1307646794-26374-1-git-send-email-timur@freescale.com> <20110609124010.6335559e.randy.dunlap@oracle.com> <4DF12345.1040409@freescale.com>
In-Reply-To: <4DF12345.1040409@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4DF123B7.004C:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/11 12:47, Timur Tabi wrote:
> Randy Dunlap wrote:
>>>> +enum fsl_hv_ioctl_cmd {
>>>> +	FSL_HV_IOCTL_PARTITION_RESTART = _IOWR(0, 1, struct fsl_hv_ioctl_restart),
>>>> +	FSL_HV_IOCTL_PARTITION_GET_STATUS = _IOWR(0, 2, struct fsl_hv_ioctl_status),
>>>> +	FSL_HV_IOCTL_PARTITION_START = _IOWR(0, 3, struct fsl_hv_ioctl_start),
>>>> +	FSL_HV_IOCTL_PARTITION_STOP = _IOWR(0, 4, struct fsl_hv_ioctl_stop),
>>>> +	FSL_HV_IOCTL_MEMCPY = _IOWR(0, 5, struct fsl_hv_ioctl_memcpy),
>>>> +	FSL_HV_IOCTL_DOORBELL = _IOWR(0, 6, struct fsl_hv_ioctl_doorbell),
>>>> +	FSL_HV_IOCTL_GETPROP = _IOWR(0, 7, struct fsl_hv_ioctl_prop),
>>>> +	FSL_HV_IOCTL_SETPROP = _IOWR(0, 8, struct fsl_hv_ioctl_prop),
>>>> +};
> 
>> Missing an entry in Documentation/ioctl/ioctl-number.txt for 0 (with conflict!).
> 
> If I change it from 0, I'm going to break binary compatibility with our apps.  I
> agree that maybe I shouldn't have picked 0, but considering how many conflicts
> there already are, I wonder what the point is.  Even if I pick a number that is
> currently not listed in the chart, that doesn't mean that it's actually not
> being used, or that it won't conflict in the future.

Yes, I understood that.

> So is it okay to stick with 0, or do I need to pick a new number?

I wasn't suggesting that you change the 0, just note that it has conflicts,
like other ioctls do.


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
