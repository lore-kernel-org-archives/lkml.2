Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757793Ab1ANSQR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 13:16:17 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:52205 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab1ANSQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 13:16:11 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6226"; a="70275402"
From: David Brown <davidb@codeaurora.org>
To: Dima Zavin <dima@android.com>
Cc: Daniel Walker <dwalker@codeaurora.org>,
        Gregory Bean <gbean@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: msm: 7x30: don't force a gpiomux table for the whole arch
In-Reply-To: <1294686030-9817-1-git-send-email-dima@android.com> (Dima Zavin's
	message of "Mon, 10 Jan 2011 11:00:30 -0800")
References: <1294680810.12298.2.camel@c-dwalke-linux.qualcomm.com>
	<1294686030-9817-1-git-send-email-dima@android.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
Date: Fri, 14 Jan 2011 10:16:10 -0800
Message-ID: <8yalj2nfj11.fsf@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10 2011, Dima Zavin wrote:

> This is completely board specific and therefore must be provided
> on a per-board basis.
>
> Change-Id: I96f922ad9bb9cbce7874c5ae6ac0d7479b7a2124
> Signed-off-by: Dima Zavin <dima@android.com>

I'll pull this into msm-next once rc8-rc1 comes out.

I'll take out the Change-Id line, though.

David
