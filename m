Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab2BCTm6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 14:42:58 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3565 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929Ab2BCTm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 14:42:57 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6609"; a="158085912"
Message-ID: <4F2C38BD.1060109@codeaurora.org>
Date: Fri, 03 Feb 2012 11:42:53 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@vyatta.com>
CC: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tags: fix regex passed to etags
References: <20120203112701.1c12b12c@s6510.linuxnetplumber.net>
In-Reply-To: <20120203112701.1c12b12c@s6510.linuxnetplumber.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/12 11:27, Stephen Hemminger wrote:
> Several of the regular expressions passed to etags where incorrect
> and missing the backslash before the closing parenthesis, causing warning:
>   etags: Unmatched ( or \( while compiling pattern
>
> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
>

I'm confused how ctags didn't complain at me. It worked for me when I
tried it. Next time I'll try both. Thanks.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

