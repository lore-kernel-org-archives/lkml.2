Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932882Ab0FUR2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 13:28:35 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35216 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757714Ab0FUR2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 13:28:33 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6020"; a="45072868"
Message-ID: <4C1FA141.30006@codeaurora.org>
Date: Mon, 21 Jun 2010 10:28:33 -0700
From: Bryan Huntsman <bryanh@codeaurora.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Pavel Machek <pavel@ucw.cz>, Gregory Bean <gbean@codeaurora.org>,
       dwalker@codeaurora.org, linux-arm-msm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] msm: Add gpio register address mapping information.
References: <1276888375-13221-1-git-send-email-gbean@codeaurora.org>	<1276888375-13221-2-git-send-email-gbean@codeaurora.org>	<20100619200249.GA2507@elf.ucw.cz>	<4C1F9B58.6020302@codeaurora.org> <20100621181851.53de5f62@lxorguk.ukuu.org.uk>
In-Reply-To: <20100621181851.53de5f62@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>>> Yeah. Either this can be replaced with GPL, and it such case just do
>>> so, or it can not, and then it can not be applied to kernel.
>>>
>> This is a standard BSD-style license so it's compatible w/ the GPL.  Thanks.
> 
> The kernel requires GPL, and its much much easier for everyone to state
> so explicitly to avoid future surprises (remember 4 clause BSD was once
> thought GPL compatible even by the FSF...)
> 
> If you want to make it clear it's also available BSD licensed in this
> form (at least until someone changes it) see the wording in files like
> drivers/char/random.c
> 
> That usually keeps all the lawyers happy.
> 
> Alan

Keeping the lawyers happy certainly has it's challenges.  Is it uncommon 
to use just a BSD-style license for headers?  I understand that everyone 
would prefer just GPL.  I'm primarily curious about preserving BSD 
licensing for headers under /include.  A dual license would work, but 
would it also be frowned upon to use just a 3-clause BSD license like we 
have in this patch?  Thanks.

- Bryan

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
