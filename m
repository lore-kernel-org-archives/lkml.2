Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104Ab1BKXfV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 18:35:21 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:14758 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757300Ab1BKXfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 18:35:17 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6254"; a="74126227"
Subject: Re: [PATCH 2/3] msm: iommu: Generalize platform data for multiple
 targets
From: Daniel Walker <dwalker@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: Stepan Moskovchenko <stepanm@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <8ya1v3ekvqg.fsf@huya.qualcomm.com>
References: <1297456098-3241-1-git-send-email-stepanm@codeaurora.org>
	 <1297456098-3241-2-git-send-email-stepanm@codeaurora.org>
	 <1297462350.4852.31.camel@m0nster> <8ya7hd6kxk1.fsf@huya.qualcomm.com>
	 <1297464456.4852.34.camel@m0nster>  <8ya1v3ekvqg.fsf@huya.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Feb 2011 15:35:17 -0800
Message-ID: <1297467317.4852.36.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-11 at 15:16 -0800, David Brown wrote:
> On Fri, Feb 11 2011, Daniel Walker wrote:
> 
> > On Fri, 2011-02-11 at 14:37 -0800, David Brown wrote:
> 
> >> It is functionality that will be shared across multiple socs.  Putting
> >> the name of a specific soc would just be misleading.  Currently, it's
> >> our only iommu.  Support for another family that uses a different iommu
> >> could perhaps call it iommu2.
> >
> > Your missing my point. I'm saying it doesn't look flexible enough to
> > allow support for multiple SoCs .. Is everything going to be identical
> > across all the supported socs ?
> 
> It wouldn't help, though.  If the addresses differ across targets, we
> don't want defines that are conditionally defined, so we would need
> multiple tables, giving the address for specific targets.  Still no
> reason to have an indirection on the names.

I'm talking about the whole deal here, this whole patch series. It
doesn't seem like this has been thought out too well. 

Daniel

-- 
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
Forum.


