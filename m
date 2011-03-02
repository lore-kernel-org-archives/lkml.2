Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578Ab1CBV0p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 16:26:45 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:3598 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587Ab1CBV0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 16:26:43 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6273"; a="77640351"
Message-ID: <9d6dd47e36dafad4e2f876d994f607e2.squirrel@www.codeaurora.org>
In-Reply-To: <1299100671-11665-1-git-send-email-carlv@codeaurora.org>
References: <1299100542-11120-1-git-send-email-carlv@codeaurora.org>
    <1299100671-11665-1-git-send-email-carlv@codeaurora.org>
Date: Wed, 2 Mar 2011 13:26:22 -0800 (PST)
Subject: Re: [PATCH 3/4] [ARM] msm_fb: Fix framebuffer console
From: "Carl Vanderlip" <carlv@codeaurora.org>
To: Arve =?iso-8859-1?Q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Carl Vanderlip" <carlv@codeaurora.org>,
        linux-fbdev@vger.kernel.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-02 at 13:17 -0800, Carl Vanderlip wrote:
> From: Arve Hjønnevåg <arve@android.com>
>
> Don't allow non panning updates to bypass the wait for the panel to turn
on.
>
> Signed-off-by: Carl Vanderlip <carlv@codeaurora.org>

Arve,

	This patch did not have a SOB from you. Would you sign off on this patch?

    -Carl V.


