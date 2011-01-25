Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab1AYVj1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 16:39:27 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:45267 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643Ab1AYVj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 16:39:26 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6237"; a="71741680"
Subject: Re: [PATCH 1/4] msm: clock: Remove unused code and definitions
From: Daniel Walker <dwalker@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>,
        Saravana Kannan <skannan@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
In-Reply-To: <1295927118-27591-2-git-send-email-sboyd@codeaurora.org>
References: <1295927118-27591-1-git-send-email-sboyd@codeaurora.org>
	 <1295927118-27591-2-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 Jan 2011 13:38:57 -0800
Message-ID: <1295991537.25496.49.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-24 at 19:45 -0800, Stephen Boyd wrote:
> Remove dead code and push out clock-7x30.h and clock-pcom.h to
> where they are actually used.
> 

I'd do two patches for this. The stuff your doing is too disconnected.

Daniel

-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

