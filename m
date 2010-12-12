Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab0LLVl2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 16:41:28 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:48131 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510Ab0LLVl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 16:41:27 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6195"; a="66530539"
Message-ID: <25fe5fad8d9b14d10c502549f0b475ec.squirrel@codeaurora.org>
In-Reply-To: <20101212135305.GI15189@opensource.wolfsonmicro.com>
References: <1292151342-12970-1-git-send-email-skannan@codeaurora.org>
    <20101212135305.GI15189@opensource.wolfsonmicro.com>
Date: Sun, 12 Dec 2010 13:41:13 -0800 (PST)
Subject: Re: [PATCH] regulator: Call into regulator driver only when 
     voltage min/max really changes.
From: "Saravana Kannan" <skannan@codeaurora.org>
To: "Mark Brown" <broonie@opensource.wolfsonmicro.com>
Cc: "Saravana Kannan" <skannan@codeaurora.org>,
        "Liam Girdwood" <lrg@slimlogic.co.uk>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So, I tried to apply this against my local tree to avoid collisions with
> it but it doesn't apply so I suspect Liam will have trouble also, there
> are several updates in there that overlap with your change.  Please
> regenerate against -next or Liam's tree:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6
>
> You should always submit changes against the development versions of
> code, generally -next will have these merged into it.
>
Will do. From a quick git log made it looked like for-linus was the
latest. Looks like I was mistaken.

-Saravana
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


