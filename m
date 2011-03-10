Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838Ab1CJUMS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 15:12:18 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35784 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab1CJUMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 15:12:17 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6281"; a="79234807"
From: David Brown <davidb@codeaurora.org>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        linux-arm-msm@vger.kernel.org,
        Saravana Kannan <skannan@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] msm: 8660: Add clock control regions to iomap
References: <1299732274-10742-1-git-send-email-sboyd@codeaurora.org>
	<1299732274-10742-2-git-send-email-sboyd@codeaurora.org>
	<4D78F0D8.7000408@ru.mvista.com>
Date: Thu, 10 Mar 2011 12:12:23 -0800
In-Reply-To: <4D78F0D8.7000408@ru.mvista.com> (Sergei Shtylyov's message of
	"Thu, 10 Mar 2011 18:40:08 +0300")
Message-ID: <8yapqpyag60.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10 2011, Sergei Shtylyov wrote:

> Hello.
>
> On 10-03-2011 7:44, Stephen Boyd wrote:
>
>> Change-Id: I9e72f10d0da1d6aaaaf7df85d33b998edf424f6f
>
>    This shouldn't be here.

I can remove the Change-Id when applying the patch, if there aren't any
other comments.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
