Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab1AYVwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 16:52:25 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:40908 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab1AYVwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 16:52:24 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6237"; a="71958799"
Message-ID: <4D3F4609.3000808@codeaurora.org>
Date: Tue, 25 Jan 2011 13:52:09 -0800
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Daniel Walker <dwalker@codeaurora.org>
CC: Stephen Boyd <sboyd@codeaurora.org>, David Brown <davidb@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/4] msm: clock: Remove unused code and definitions
References: <1295927118-27591-1-git-send-email-sboyd@codeaurora.org>	 <1295927118-27591-2-git-send-email-sboyd@codeaurora.org> <1295991537.25496.49.camel@c-dwalke-linux.qualcomm.com>
In-Reply-To: <1295991537.25496.49.camel@c-dwalke-linux.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2011 01:38 PM, Daniel Walker wrote:
> On Mon, 2011-01-24 at 19:45 -0800, Stephen Boyd wrote:
>> Remove dead code and push out clock-7x30.h and clock-pcom.h to
>> where they are actually used.
>>
>
> I'd do two patches for this. The stuff your doing is too disconnected.
>
> Daniel
>
There is a whole bunch of unused code in the clock files and it's being 
deleted. I don't see a point of splitting it up per file.

-Saravana

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
