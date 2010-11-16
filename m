Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab0KPUbU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 15:31:20 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:13282 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200Ab0KPUbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 15:31:19 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6169"; a="63091785"
Subject: Re: [PATCH 1/3] msm: sirc: warning fix
From: Daniel Walker <dwalker@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1289598593-8974-1-git-send-email-davidb@codeaurora.org>
References: <1289598593-8974-1-git-send-email-davidb@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Nov 2010 12:30:57 -0800
Message-ID: <1289939457.9950.1.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-12 at 13:49 -0800, David Brown wrote:
> Eliminate some unreferenced variables.
> 
> arch/arm/mach-msm/sirc.c:43: warning: 'save_type' defined but not used
> arch/arm/mach-msm/sirc.c:44: warning: 'save_polarity' defined but not used


I accepted these three , but I altered the commit test to change the
shortlog so it's a little more descriptive. Changes below,

msm: sirc: remove some unused variables
msm: smd: ifdef adjustment to remove unused variables
msm: make constant unsigned long to correct format warning


Daniel

-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

