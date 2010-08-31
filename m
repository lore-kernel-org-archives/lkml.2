Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954Ab0HaVvM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 17:51:12 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:30985 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909Ab0HaVvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 17:51:10 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6091"; a="52792024"
Subject: Re: [PATCH 1/2] msm: Install the Google-Android gpio driver.
From: Daniel Walker <dwalker@codeaurora.org>
To: Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Gregory Bean <gbean@codeaurora.org>
In-Reply-To: <1283213906-17671-1-git-send-email-gbean@codeaurora.org>
References: <1283213906-17671-1-git-send-email-gbean@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 Aug 2010 14:50:55 -0700
Message-ID: <1283291455.11790.38.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-30 at 17:18 -0700, Gregory Bean wrote:
> From: Arve Hjønnevåg <arve@android.com>
> 
> As part of the ongoing effort to converge on a common code base,
> adopt the Google-Android msmgpio driver, as it has a stronger pedigree
> than the previous submission from codeaurora.
> 
> Cc: Arve Hjønnevåg <arve@android.com>

Arve, Are you planning to move this forward or is Greg going to? I've
asked Greg (or you) for some changes to this.. If you have a problem
with the changes please speak up ..

The signed-off is wrong on this commit also, You need to sign off on the
commit (and Greg if needed).

Daniel


-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

