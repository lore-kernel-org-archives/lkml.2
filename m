Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab1A0ATu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 19:19:50 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:60829 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754376Ab1A0ATs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 19:19:48 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6238"; a="71900150"
From: David Brown <davidb@codeaurora.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Niranjana Vishwanathapura <nvishwan@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] msm: smd: Add smd_pkt driver
In-Reply-To: <20110126153240.9cc6c2e2.akpm@linux-foundation.org> (Andrew
	Morton's message of "Wed, 26 Jan 2011 15:32:40 -0800")
References: <1292437675-11561-1-git-send-email-nvishwan@codeaurora.org>
	<8yatygweqng.fsf@huya.qualcomm.com>
	<20110126153240.9cc6c2e2.akpm@linux-foundation.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
X-Hashcash: 1:20:110127:linux-arm-kernel@lists.infradead.org::Y9HAD9L55Qoqzhby:00000000000000000000000007hVY
X-Hashcash: 1:20:110127:nvishwan@codeaurora.org::F0qlavg/DbrjKniF:000000000000000000000000000000000000004OmE
X-Hashcash: 1:20:110127:linux-kernel@vger.kernel.org::U0kBtBE0GiGkKIFx:0000000000000000000000000000000009Q0e
X-Hashcash: 1:20:110127:linux-arm-msm@vger.kernel.org::RUm3DVkrVw66BJN/:00000000000000000000000000000000Bwyc
X-Hashcash: 1:20:110127:akpm@linux-foundation.org::8Liz/yrFPzkz5tfs:000000000000000000000000000000000000BinD
Date: Wed, 26 Jan 2011 16:19:48 -0800
Message-ID: <8yavd1b5haz.fsf@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26 2011, Andrew Morton wrote:

> On Tue, 25 Jan 2011 11:20:51 -0800
> David Brown <davidb@codeaurora.org> wrote:
>
>> On Wed, Dec 15 2010, Niranjana Vishwanathapura wrote:
>> 
>> > Add smd_pkt driver which provides device interface
>> > to smd packet ports.
>
> Looks OK, I grabbed it.
>
> I read the entire email trying to work out what an "SMD" is.  Failed. 
> Oh well.

Looks like it's time for me to send another round of the "people outside
our company probably don't know what our acronyms stand for" email.

Thanks,
David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
