Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932622Ab1BYTAa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 14:00:30 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:2690 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756322Ab1BYTA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 14:00:28 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6268"; a="76726483"
From: David Brown <davidb@codeaurora.org>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Kenneth Heitke <kheitke@codeaurora.org>, dima@android.com,
        linux-arm-msm@vger.kernel.org, tsoni@codeaurora.org,
        linux-arm-kernel@lists.infradead.org, swetland@google.com,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] msm: add single-wire serial bus interface (SSBI) driver
In-Reply-To: <1298600621.17118.27.camel@m0nster> (Daniel Walker's message of
	"Thu, 24 Feb 2011 18:23:41 -0800")
References: <1298585954-22422-1-git-send-email-kheitke@codeaurora.org>
	<1298585954-22422-3-git-send-email-kheitke@codeaurora.org>
	<1298600621.17118.27.camel@m0nster>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
X-Hashcash: 1:20:110225:dima@android.com::ygXU+nD1835NqT4y:00L37
X-Hashcash: 1:20:110225:dwalker@fifo99.com::8dUfPJpevBDj5bj7:00000000000000000000000000000000000000000001xfZ
X-Hashcash: 1:20:110225:linux-arm-msm@vger.kernel.org::xlWHQrCf5j4qHVqg:000000000000000000000000000000003JLR
X-Hashcash: 1:20:110225:kheitke@codeaurora.org::B/55oGWt+Y2iyFxx:00000000000000000000000000000000000000061pR
X-Hashcash: 1:20:110225:swetland@google.com::4P5HOGtzwy9NVJqf:0000000000000000000000000000000000000000004Azy
X-Hashcash: 1:20:110225:tsoni@codeaurora.org::qUZecDlMZG7I6JKV:000000000000000000000000000000000000000005WXF
X-Hashcash: 1:20:110225:linux-arm-kernel@lists.infradead.org::LpVeSgqJVwihccUF:00000000000000000000000007DNt
X-Hashcash: 1:20:110225:linux-kernel@vger.kernel.org::w7NstSEw5waN010z:000000000000000000000000000000000G25n
Date: Fri, 25 Feb 2011 11:00:27 -0800
Message-ID: <8yak4go9bxw.fsf@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24 2011, Daniel Walker wrote:

>> Based on a patch by Dima Zavin <dima@android.com> that can be found at:
>> http://android.git.kernel.org/?p=kernel/msm.git;a=commitdiff;h=eb060bac4
>
> I don't really like links in the commit text, cause as soon as Google
> deletes this tree the link is worthless.

I'm not sure how to better convey the information.  The tree is at least
on kernel.org, and there's good useful information there that works
now.  Links in commit text seem fairly common.

I think it is helpful to demonstrate that Ken is trying to be diligent
about indicating where the code comes from.

Thanks,
David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
