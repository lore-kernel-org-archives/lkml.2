Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235Ab1AXWQl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 17:16:41 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:2493 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687Ab1AXWQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 17:16:39 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6236"; a="71811369"
Subject: Re: [PATCH v2 07/11] msm: Add MSM 8960 cpu_is check
From: Daniel Walker <dwalker@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <8ya8vyakl1o.fsf@huya.qualcomm.com>
References: <1292384961-8851-1-git-send-email-stepanm@codeaurora.org>
	 <1295468747-22796-1-git-send-email-davidb@codeaurora.org>
	 <1295468747-22796-8-git-send-email-davidb@codeaurora.org>
	 <1295901976.29639.53.camel@c-dwalke-linux.qualcomm.com>
	 <8yak4hukn00.fsf@huya.qualcomm.com>
	 <1295904928.29639.58.camel@c-dwalke-linux.qualcomm.com>
	 <8ya8vyakl1o.fsf@huya.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 Jan 2011 14:16:11 -0800
Message-ID: <1295907371.29639.61.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-24 at 14:13 -0800, David Brown wrote:
> On Mon, Jan 24 2011, Daniel Walker wrote:
> 
> >> What do you want me to call it?
> >> 
> >>   #define cpu_is_97d0c886-3768-4998-8925-16f36209d0d1()
> >
> > I want you to call it msm8x60 ..
> 
> msm8960 is not a subset of msm8x60.  It's just a misleading name.  It's
> a very different device, and needs it's own identifier.

Can you site reason why it's different .. My impression is that it's not
as different as you think it is.

Daniel

-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

