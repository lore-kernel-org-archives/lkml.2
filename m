Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759059Ab0KPBQt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 20:16:49 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:60632 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758980Ab0KPBQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 20:16:48 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6168"; a="62973343"
Message-ID: <4CE1DB7F.1020408@codeaurora.org>
Date: Mon, 15 Nov 2010 17:16:47 -0800
From: Stepan Moskovchenko <stepanm@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.11) Gecko/20101013 Thunderbird/3.1.5
MIME-Version: 1.0
To: Daniel Walker <dwalker@codeaurora.org>
CC: davidb@codeaurora.org, bryanh@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/14] msm: iommu: Miscellaneous code cleanup
References: <1289619000-13167-1-git-send-email-stepanm@codeaurora.org>	 <1289619000-13167-15-git-send-email-stepanm@codeaurora.org> <1289867105.4050.29.camel@c-dwalke-linux.qualcomm.com>
In-Reply-To: <1289867105.4050.29.camel@c-dwalke-linux.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2010 4:25 PM, Daniel Walker wrote:
> On Fri, 2010-11-12 at 19:30 -0800, Stepan Moskovchenko wrote:
>> Remove some unneeded assignments and messages, restructure
>> a failure path in iova_to_phys, and make __flush_iotlb
>> return int in preparation for adding IOMMU clock control.
> Why restructure the failure path ?
>
> Daniel

It is a trivial change of replacing a goto with an assignment and moving 
it a few lines down. It reduces "jumpiness" within that function and is 
a cleaner version. On the more practical side, it was done in 
preparation for some other changes I have coming up, which touch that 
function and work a lot better with the cleaned-up failure path. The 
next patch was delayed (due to a dependency) but as long as I was doing 
code cleanup, I saw no reason not to also clean up the failure path as 
part of this series.

Steve

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

