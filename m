Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771Ab1BYCbk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 21:31:40 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11295 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab1BYCbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 21:31:39 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6267"; a="76357177"
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
X-Hashcash: 1:20:110225:dima@android.com::PV5/CtT2c6NzBDO+:01sYx
X-Hashcash: 1:20:110225:swetland@google.com::n1sSIkqkfkpHjBDd:00000000000000000000000000000000000000000013yT
X-Hashcash: 1:20:110225:kheitke@codeaurora.org::IrIdsA7b38aUcBXb:0000000000000000000000000000000000000003tmo
X-Hashcash: 1:20:110225:dwalker@fifo99.com::rGH9krdcbnc/iMKz:00000000000000000000000000000000000000000003NYD
X-Hashcash: 1:20:110225:linux-arm-msm@vger.kernel.org::ARz9RTSRRVIm+LUI:000000000000000000000000000000002SQE
X-Hashcash: 1:20:110225:linux-kernel@vger.kernel.org::SsjZQlWafczGLrak:0000000000000000000000000000000004Tb+
X-Hashcash: 1:20:110225:tsoni@codeaurora.org::4/Buyt6UApLRJ0cc:000000000000000000000000000000000000000008nt2
X-Hashcash: 1:20:110225:linux-arm-kernel@lists.infradead.org::qEMrwp05iztvhqyL:00000000000000000000000008cfk
Date: Thu, 24 Feb 2011 18:31:38 -0800
Message-ID: <8yad3mgdeut.fsf@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24 2011, Daniel Walker wrote:

> You have some submission problems. one is that the subject should be
> "drivers: msm: ..." , this patch also shouldn't go to David.

Subject needs to be fixed.  Patch to add drivers/msm to the maintainers
file has been Acked, so this should be sent to the MSM maintainers.

David
