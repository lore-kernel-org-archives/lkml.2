Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab2BGTSr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 14:18:47 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:15639 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756607Ab2BGTSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 14:18:46 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6613"; a="158955336"
Message-ID: <4F317915.4040609@codeaurora.org>
Date: Tue, 07 Feb 2012 11:18:45 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@vyatta.com>
CC: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tags: fix use of parenthesis in regex
References: <20120203112701.1c12b12c@s6510.linuxnetplumber.net>	<4F2C38BD.1060109@codeaurora.org>	<20120203121847.1b01f4b5@s6510.linuxnetplumber.net>	<c1f3d71b6001dfc42ded4ee651e9a82c.squirrel@www.codeaurora.org>	<20120206124058.1cf1a23e@s6510.linuxnetplumber.net>	<4F305CB6.7050603@codeaurora.org> <20120206151543.1bb1d869@s6510.linuxnetplumber.net>
In-Reply-To: <20120206151543.1bb1d869@s6510.linuxnetplumber.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/12 15:15, Stephen Hemminger wrote:
> Several of the regular expressions passed to etags and ctags where incorrect
> and missing the backslash before the closing paren, and matching the wrong
> part of the start of the function causing warning:
>   etags: Unmatched ( or \( while compiling pattern
>
> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
>

Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

