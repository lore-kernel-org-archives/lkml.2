Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778Ab0CQUPi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 16:15:38 -0400
Received: from mail-gx0-f217.google.com ([209.85.217.217]:52380 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935Ab0CQUPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 16:15:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=uR+EH5rGxSVYVJzezCubsWKH0nuQpuYSBdUX67mH9tC8DiHGbTE5AT9B6BSlhQcdvm
         ObigMkX1iw0/qdsnadzlQgpSnk6KMS+dTVgIl+nzNH4qB/jrATiyhIZ3iVvPkKRHgCfE
         Bfb1eZDGMxNTX/+tpNhEIeHYIky5cmvQ/odWk=
Message-ID: <4BA13865.4080408@pobox.com>
Date: Wed, 17 Mar 2010 16:15:33 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: Stefan Roese <sr@denx.de>, Rupjyoti Sarmah <rsarmah@amcc.com>
CC: linuxppc-dev@lists.ozlabs.org, linux-ide@vger.kernel.org,
       Rupjyoti Sarmah <rupjyoti.sarmah@gmail.com>, linuxppc-dev@ozlabs.org,
       Rupjyoti Sarmah <rupjyoti.sarmah@appliedmicro.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 460EX on-chip SATA driver<kernel 2.6.33> < resubmission
 : 01>
References: <1268646854-27387-1-git-send-email-rsarmah@appliedmicro.com> <AC311A8E81420D4EBC1F26E6479848FE065B7F30@SDCEXCHANGE01.ad.amcc.com> <201003171303.06258.sr@denx.de>
In-Reply-To: <201003171303.06258.sr@denx.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2010 08:03 AM, Stefan Roese wrote:
> Hi Rup,
>
> On Wednesday 17 March 2010 05:23:16 Rupjyoti Sarmah wrote:
>> This patch enables the on-chip DWC SATA controller of the AppliedMicro
>> processor 460EX.
>
> Apart from the other comments, did you take a look at the latest version of
> this driver in our linux-2.6-denx repository? We did some work on this driver
> for a new Canyonlands release last year. It's hard to check this for me now,
> with this line wrapped patch (the drivers diverged somewhat). So either check
> for yourself, or send a new, not line-wrapped, patch version so that I can
> better check myself.
>
> BTW: It would be nice if you would add me to Cc on DWC-SATA related patches,
> since I've been involved in the development at some time.

I will wait for Rupjyoti to check the linux-2.6-denx repo, and resend 
the patches without word wrapping.

	Jeff



