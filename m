Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748Ab1AXVbq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 16:31:46 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:26839 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949Ab1AXVbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 16:31:44 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6236"; a="71592102"
From: David Brown <davidb@codeaurora.org>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 04/11] msm: io: I/O register definitions for MSM8960
References: <1292384961-8851-1-git-send-email-stepanm@codeaurora.org>
	<1295468747-22796-1-git-send-email-davidb@codeaurora.org>
	<1295468747-22796-5-git-send-email-davidb@codeaurora.org>
	<1295902153.29639.54.camel@c-dwalke-linux.qualcomm.com>
X-Hashcash: 1:20:110124:dwalker@codeaurora.org::USG7K0D3NFNfZHr6:000000000000000000000000000000000000000055m
X-Hashcash: 1:20:110124:linux-arm-msm@vger.kernel.org::sgnyKdgbsOcB36K7:000000000000000000000000000000000710
X-Hashcash: 1:20:110124:linux-arm-kernel@lists.infradead.org::a4Bfm3x5KTfUtd4c:00000000000000000000000001n18
X-Hashcash: 1:20:110124:arnd@arndb.de::qSI5rqzO/cbakKYv:00001UCR
X-Hashcash: 1:20:110124:stepanm@codeaurora.org::45Y7GXloB+5HFEAM:0000000000000000000000000000000000000002QM6
X-Hashcash: 1:20:110124:linux-kernel@vger.kernel.org::rgWRbF0SyBkPtrHk:0000000000000000000000000000000003tD4
Date: Mon, 24 Jan 2011 13:31:44 -0800
In-Reply-To: <1295902153.29639.54.camel@c-dwalke-linux.qualcomm.com> (Daniel
	Walker's message of "Mon, 24 Jan 2011 12:49:13 -0800")
Message-ID: <8yafwsikmyn.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24 2011, Daniel Walker wrote:

> On Wed, 2011-01-19 at 12:25 -0800, David Brown wrote:
>> +/*
>> + * Copyright (C) 2007 Google, Inc.
>> + * Copyright (c) 2008-2011, Code Aurora Forum. All rights reserved.
>> + * Author: Brian Swetland <swetland@google.com>
>
> Brian didn't really write this did he?

He wrote the code it is based off of.  The author line could probably be
removed.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
