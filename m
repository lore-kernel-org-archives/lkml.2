Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558Ab1ANVIf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 16:08:35 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:59625 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab1ANVIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 16:08:31 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6226"; a="70506525"
Subject: Re: [PATCH] ARM: msm: 7x30: don't force a gpiomux table for the
 whole arch
From: Daniel Walker <dwalker@codeaurora.org>
To: Rohit Vaswani <rvaswani@codeaurora.org>
Cc: Dima Zavin <dima@android.com>, Gregory Bean <gbean@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <4D2FC49A.1000505@codeaurora.org>
References: <1294680810.12298.2.camel@c-dwalke-linux.qualcomm.com>
	 <1294686030-9817-1-git-send-email-dima@android.com>
	 <4D2FC49A.1000505@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Jan 2011 13:08:21 -0800
Message-ID: <1295039301.4129.14.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-13 at 19:35 -0800, Rohit Vaswani wrote:
> On 1/10/2011 11:00 AM, Dima Zavin wrote:
> > This is completely board specific and therefore must be provided
> > on a per-board basis.
> >
> > Change-Id: I96f922ad9bb9cbce7874c5ae6ac0d7479b7a2124
> > Signed-off-by: Dima Zavin<dima@android.com>
> >
> Tested-by: Rohit Vaswani <rvaswani@codeaurora.org>

Rohit, do you have patches to do this for all the SoCs?

Daniel


-- 
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
Forum.


