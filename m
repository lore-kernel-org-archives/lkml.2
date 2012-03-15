Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161144Ab2COR57 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 13:57:59 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:48653 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755827Ab2COR54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 13:57:56 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6650"; a="172812292"
Message-ID: <4F622D9F.1070101@codeaurora.org>
Date: Thu, 15 Mar 2012 23:27:51 +0530
From: Ravi Kumar V <kumarrav@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Shantanu Gupta <shans95g@gmail.com>
CC: Daniel Walker <dwalker@fifo99.com>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH v3 2/2] DMAEngine: Add DMAEngine driver based on old MSM
 DMA APIs
References: <1331548364-27845-1-git-send-email-kumarrav@codeaurora.org> <20120312201421.GA3459@fifo99.com> <CAPDArRLs23VDJSWpX8xJsXfn+_SV2FcyzLYBF9UAxf=Rv9svGQ@mail.gmail.com>
In-Reply-To: <CAPDArRLs23VDJSWpX8xJsXfn+_SV2FcyzLYBF9UAxf=Rv9svGQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/13/2012 4:27 PM, Shantanu Gupta wrote:
> Any info available(publicly) on so as to what all chipsets have this
> capability ?

This is DMA engine driver for "Application Data Mover(ADM)" which in one 
type of DMA device in most of the Qualcomm processors like snapdragon.

>
> On Tue, Mar 13, 2012 at 1:44 AM, Daniel Walker <dwalker@fifo99.com
> <mailto:dwalker@fifo99.com>> wrote:
>
>     On Mon, Mar 12, 2012 at 04:02:44PM +0530, Ravi Kumar V wrote:
>      > Add DMAEngine based driver using the old MSM DMA APIs internally.s
>
>     What do you mean by this?
>
>      > The benefit of this approach is that not all the drivers
>      > have to get converted to DMAEngine APIs simultaneosly while
>      > both the drivers can stay enabled in the kernel. The client
>      > drivers using the old MSM APIs directly can now convert to
>      > DMAEngine one by one.
>
>     Which drivers?
>
>     Daniel
>     --
>     To unsubscribe from this list: send the line "unsubscribe
>     linux-arm-msm" in
>     the body of a message to majordomo@vger.kernel.org
>     <mailto:majordomo@vger.kernel.org>
>     More majordomo info at http://vger.kernel.org/majordomo-info.html
>
>


-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
