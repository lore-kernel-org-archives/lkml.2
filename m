Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679Ab0GBASt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 20:18:49 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:61775 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497Ab0GBASr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 20:18:47 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6030"; a="46083038"
Message-ID: <4C2D3066.9040104@codeaurora.org>
Date: Thu, 01 Jul 2010 17:18:46 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: Daniel Walker <dwalker@codeaurora.org>,
       LKML <linux-kernel@vger.kernel.org>,
       dri-devel <dri-devel@lists.freedesktop.org>,
       linux-arm-msm@vger.kernel.org, jcrouse@codeaurora.org
Subject: Re: Closed source userspace graphics drivers with an open source
 	kernel component
References: <AANLkTikfYwkxF5CXgt-fGMIYTlcmt99lOz_VyA3Kr-4R@mail.gmail.com>	<AANLkTimgH-DiQyg0f-an5FS3Wyb2b6He3fxxB1L8Ziol@mail.gmail.com>	<1278024678.7738.54.camel@c-dwalke-linux.qualcomm.com>	<AANLkTinNrpcBg0TXTS78qaI5kPQKD-IbnLpDStu4_BIg@mail.gmail.com>	<1278026975.7738.89.camel@c-dwalke-linux.qualcomm.com>	<AANLkTilGdNgWIprJ2XZ2gSv2d-DVybGmb9phcboi4fNL@mail.gmail.com>	<1278029284.7738.116.camel@c-dwalke-linux.qualcomm.com> <AANLkTilEKPmHKNDNbNpmUvcYC338YezLkNBc4ShfTFdp@mail.gmail.com>
In-Reply-To: <AANLkTilEKPmHKNDNbNpmUvcYC338YezLkNBc4ShfTFdp@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Airlie wrote:
> This is more about initial development stages. We maintain kernel
> API/ABI for all in-tree drivers, however before we put a driver into
> mainline, we usually need to redo the crazy interfaces that vendors
> have come up with. Like 32/64 alignment, passing userspace addresses
> into the kernel, passing phy addresses to userspace etc. If the
> userspace binary is closed that process becomes next to impossible.

My 2 cents:
I think we should leave the onus of fixing the userspace to work with 
the sane kernel API with the entity trying to get their drivers into the 
kernel. I think it's a better approach (as in, more likelihood of 
getting device support) than saying, we will only allow fully open 
sourced kernel drivers.

-Saravana
