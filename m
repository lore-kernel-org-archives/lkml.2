Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932401Ab2E3Iwe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 04:52:34 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:51673 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932264Ab2E3Iwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 04:52:33 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6726"; a="193558291"
Message-ID: <4FC5DFCF.1020606@codeaurora.org>
Date: Wed, 30 May 2012 01:52:31 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@ti.com>
Subject: Re: [RFC PATCH] clk: add extension API
References: <1338285540-24407-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1338285540-24407-1-git-send-email-pdeschrijver@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/29/2012 2:58 AM, Peter De Schrijver wrote:
> Add an extension API for clocks. This allows clocktypes to provide extensions
> for features which are uncommon and cannot be easily mapped onto normal clock
> framework concecpts. eg: resetting blocks, configuring clock phase etc.

This seems rather generic. Why not add more specific APIs/concepts like
clk_reset(), clk_set_phase(), etc.? If they don't map, maybe we should
make them map.

At the least it should be documented so that people know what it should
be used for.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

