Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441Ab1HORzV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 13:55:21 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:16499 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab1HORzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 13:55:19 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6439"; a="110211680"
Message-ID: <4E495D84.6080709@codeaurora.org>
Date: Mon, 15 Aug 2011 11:55:16 -0600
From: Kenneth Heitke <kheitke@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100722 Eudora/3.0.4
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: davidb@codeaurora.org, bryanh@codeaurora.org,
        linux-arm-msm@vger.kernel.org, Sagar Dharia <sdharia@codeaurora.org>,
        rdunlap@xenotime.net, rmk+kernel@arm.linux.org.uk,
        john.stultz@linaro.org, arnd@arndb.de, akpm@linux-foundation.org,
        ohad@wizery.com, gregkh@suse.de, stefanr@s5r6.in-berlin.de,
        lethal@linux-sh.org, linville@tuxdriver.com, zajec5@gmail.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] slimbus: Linux driver framework for SLIMbus.
References: <1313019091-15354-1-git-send-email-kheitke@codeaurora.org> <20110814143401.GA25504@sirena.org.uk>
In-Reply-To: <20110814143401.GA25504@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2011 08:34 AM, Mark Brown wrote:
> On Wed, Aug 10, 2011 at 05:31:28PM -0600, Kenneth Heitke wrote:
>
>> SLIMbus (Serial Low Power Interchip Media Bus) is a specification
>> developed by MIPI (Mobile Industry Processor Interface) alliance.
>
> Please CC me on any future spins of this patch.
>

mark, thanks for reviewing the code.  I will be sure to CC you in the 
future.  I agree with your comments and will incorporate the changes in 
the next revision.

thanks,
Ken


-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
