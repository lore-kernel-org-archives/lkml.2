Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758461Ab1BKXQp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 18:16:45 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:59158 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758291Ab1BKXQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 18:16:44 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6254"; a="74124431"
From: David Brown <davidb@codeaurora.org>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Stepan Moskovchenko <stepanm@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] msm: iommu: Generalize platform data for multiple targets
In-Reply-To: <1297464456.4852.34.camel@m0nster> (Daniel Walker's message of
	"Fri, 11 Feb 2011 14:47:36 -0800")
References: <1297456098-3241-1-git-send-email-stepanm@codeaurora.org>
	<1297456098-3241-2-git-send-email-stepanm@codeaurora.org>
	<1297462350.4852.31.camel@m0nster> <8ya7hd6kxk1.fsf@huya.qualcomm.com>
	<1297464456.4852.34.camel@m0nster>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
X-Hashcash: 1:20:110211:linux-arm-kernel@lists.infradead.org::X9/wx0eIOJn16Und:0000000000000000000000000054n
X-Hashcash: 1:20:110211:dwalker@codeaurora.org::MCTEcmaNe2YWJ23C:0000000000000000000000000000000000000000Kqy
X-Hashcash: 1:20:110211:linux-arm-msm@vger.kernel.org::Cy90m/6UgrzNWs0z:000000000000000000000000000000002pXW
X-Hashcash: 1:20:110211:linux-kernel@vger.kernel.org::JIPiAFIRMpm2/8Tb:0000000000000000000000000000000004s5C
X-Hashcash: 1:20:110211:stepanm@codeaurora.org::04W7jn94psYd/RKA:0000000000000000000000000000000000000008a3p
Date: Fri, 11 Feb 2011 15:16:39 -0800
Message-ID: <8ya1v3ekvqg.fsf@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 11 2011, Daniel Walker wrote:

> On Fri, 2011-02-11 at 14:37 -0800, David Brown wrote:

>> It is functionality that will be shared across multiple socs.  Putting
>> the name of a specific soc would just be misleading.  Currently, it's
>> our only iommu.  Support for another family that uses a different iommu
>> could perhaps call it iommu2.
>
> Your missing my point. I'm saying it doesn't look flexible enough to
> allow support for multiple SoCs .. Is everything going to be identical
> across all the supported socs ?

It wouldn't help, though.  If the addresses differ across targets, we
don't want defines that are conditionally defined, so we would need
multiple tables, giving the address for specific targets.  Still no
reason to have an indirection on the names.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
