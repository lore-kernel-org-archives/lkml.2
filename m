Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab1DAIoP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 04:44:15 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:16234 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392Ab1DAIoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 04:44:14 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6302"; a="83164939"
Message-ID: <4D959058.7010606@codeaurora.org>
Date: Fri, 01 Apr 2011 01:44:08 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Simon Glass <sjg@chromium.org>
CC: Omar Ramirez Luna <omar.ramirez@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        lk <linux-kernel@vger.kernel.org>,
        lak <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: BUG() dies silently
References: <1301602523-9906-1-git-send-email-omar.ramirez@ti.com> <BANLkTimtAcPLmcFKoHkCtWcJipy+rSSP+A@mail.gmail.com>
In-Reply-To: <BANLkTimtAcPLmcFKoHkCtWcJipy+rSSP+A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/31/2011 6:47 PM, Simon Glass wrote:
> You might try the generic bug patch and see if it also fixes this
> problem - Simon

It probably won't because presumably Omar has CONFIG_BUG=n otherwise
Omar would have sent a patch against __bug() in arch/arm/kernel/traps.c

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

