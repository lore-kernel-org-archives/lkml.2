Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab1ASALq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 19:11:46 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:50146 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153Ab1ASALp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 19:11:45 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6230"; a="71012649"
From: David Brown <davidb@codeaurora.org>
To: Leo Prasath <leo.prasath@gmail.com>
Cc: linux-kernel@vger.kernel.org, Yiying Zhang <eggbaby150@gmail.com>
Subject: Re: sleep in microsecond granularity in linux
In-Reply-To: <AANLkTinjv_cLfZfNEf0LOxXAOEUNhsJ3uzPHiRVGGTWh@mail.gmail.com>
	(Leo Prasath's message of "Tue, 18 Jan 2011 17:33:34 -0600")
References: <AANLkTinjv_cLfZfNEf0LOxXAOEUNhsJ3uzPHiRVGGTWh@mail.gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
X-Hashcash: 1:20:110119:linux-kernel@vger.kernel.org::ogQ8K9vr66y9wg8o:0000000000000000000000000000000000GT5
X-Hashcash: 1:20:110119:eggbaby150@gmail.com::WHzWzsJL8/Rpsfh4:000000000000000000000000000000000000000001hy8
X-Hashcash: 1:20:110119:leo.prasath@gmail.com::P295gAbxk64nD1kW:00000000000000000000000000000000000000001vwP
Date: Tue, 18 Jan 2011 16:11:45 -0800
Message-ID: <8yak4i1sqf2.fsf@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 18 2011, Leo Prasath wrote:

> Is it possible to sleep in granularity of microseconds ?
> From what i know, there is msleep() which can sleep in milliseconds
> and there is udelay() which busy waits for time in microsecond
> granularity.
> But I need to sleep ( not busy wait ) for granularity of microseconds ...

usleep_range()  See Documentation/timers/timers-howto.txt for info, and
caveats.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
