Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab1AYTpa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 14:45:30 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44297 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab1AYTp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 14:45:29 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6237"; a="71943552"
From: David Brown <davidb@codeaurora.org>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 01/11] msm: Add CPU queries
References: <1292384961-8851-1-git-send-email-stepanm@codeaurora.org>
	<1295468747-22796-1-git-send-email-davidb@codeaurora.org>
	<1295468747-22796-2-git-send-email-davidb@codeaurora.org>
	<1295914163.29639.77.camel@c-dwalke-linux.qualcomm.com>
	<8yak4htj0lb.fsf@huya.qualcomm.com>
	<1295915034.29639.78.camel@c-dwalke-linux.qualcomm.com>
	<8yay669hka5.fsf@huya.qualcomm.com>
	<1295976910.25496.1.camel@c-dwalke-linux.qualcomm.com>
	<8ya39ogg5dm.fsf@huya.qualcomm.com>
	<1295983549.25496.33.camel@c-dwalke-linux.qualcomm.com>
X-Hashcash: 1:20:110125:linux-arm-msm@vger.kernel.org::IPW8lpGH02Ev7/Km:000000000000000000000000000000004RiL
X-Hashcash: 1:20:110125:linux-kernel@vger.kernel.org::4QGzXSYJre5d9rVo:0000000000000000000000000000000004ZYx
X-Hashcash: 1:20:110125:dwalker@codeaurora.org::P5FXIo6zIeNIpALO:0000000000000000000000000000000000000005mrN
X-Hashcash: 1:20:110125:linux-arm-kernel@lists.infradead.org::r17e3K1tXP8gi+Hg:00000000000000000000000009HPH
Date: Tue, 25 Jan 2011 11:45:29 -0800
In-Reply-To: <1295983549.25496.33.camel@c-dwalke-linux.qualcomm.com> (Daniel
	Walker's message of "Tue, 25 Jan 2011 11:25:49 -0800")
Message-ID: <8yaei80epie.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25 2011, Daniel Walker wrote:

> On Tue, 2011-01-25 at 11:17 -0800, David Brown wrote:

> I suggesting we do it across the board because consistency is a good
> thing .. It also allows us to use 8x60 when 8660 and 8960 are actually
> similar .. You can't deny that 8960 is similar to 8660 because your
> patches show some duplication due to it.

You're completely missing the point of these tests.  If _anything_ is
different, the macros need to be different.  I don't care if they're
similar, I need to know when they are different.  That is the point of
the macros.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
