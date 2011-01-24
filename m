Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab1AXWtW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 17:49:22 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:17862 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740Ab1AXWtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 17:49:21 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6236"; a="71815464"
From: David Brown <davidb@codeaurora.org>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 06/11] msm: irqs-8960: Interrupt map for MSM8960
References: <1292384961-8851-1-git-send-email-stepanm@codeaurora.org>
	<1295468747-22796-1-git-send-email-davidb@codeaurora.org>
	<1295468747-22796-7-git-send-email-davidb@codeaurora.org>
	<1295909142.29639.63.camel@c-dwalke-linux.qualcomm.com>
X-Hashcash: 1:20:110124:dwalker@codeaurora.org::IWna0at/yW4s43f2:0000000000000000000000000000000000000000MM7
X-Hashcash: 1:20:110124:linux-arm-msm@vger.kernel.org::5hKLlRGrW6DbmvH1:000000000000000000000000000000001MAG
X-Hashcash: 1:20:110124:linux-kernel@vger.kernel.org::Yc/2ufb5cH/8GP+p:0000000000000000000000000000000002j+b
X-Hashcash: 1:20:110124:stepanm@codeaurora.org::3svUf1C52694eXh0:0000000000000000000000000000000000000003XBl
X-Hashcash: 1:20:110124:linux-arm-kernel@lists.infradead.org::J75i3ZaagdI5nH+9:00000000000000000000000005nIX
Date: Mon, 24 Jan 2011 14:49:20 -0800
In-Reply-To: <1295909142.29639.63.camel@c-dwalke-linux.qualcomm.com> (Daniel
	Walker's message of "Mon, 24 Jan 2011 14:45:42 -0800")
Message-ID: <8yaaaipkjdb.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24 2011, Daniel Walker wrote:

> On Wed, 2011-01-19 at 12:25 -0800, David Brown wrote:
>> +#define SC_AVSCPUXUP                           (GIC_PPI_START + 12)
>> +#define SC_SICCPUXACGIRPTREQ                   (GIC_PPI_START + 13)
>> +#define SC_SICCPUXEXTFAULTIRPTREQ              (GIC_PPI_START + 14)
>> +/* PPI 15 is unused */ 
>
> How are you handling this at runtime?

We're not yet.  That's why it is marked as a TODO.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
