Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab1DCHQI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 03:16:08 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:58605 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab1DCHQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 03:16:01 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6304"; a="83679747"
Message-ID: <4D981EAB.8070209@codeaurora.org>
Date: Sun, 03 Apr 2011 00:15:55 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Simon Glass <sjg@chromium.org>
CC: Omar Ramirez Luna <omar.ramirez@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        lk <linux-kernel@vger.kernel.org>,
        lak <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: BUG() dies silently
References: <1301602523-9906-1-git-send-email-omar.ramirez@ti.com>	<BANLkTimtAcPLmcFKoHkCtWcJipy+rSSP+A@mail.gmail.com>	<4D959058.7010606@codeaurora.org> <BANLkTim8GhUAZ7L-MiJiqi6xM=P_Q8kqfg@mail.gmail.com>
In-Reply-To: <BANLkTim8GhUAZ7L-MiJiqi6xM=P_Q8kqfg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Please stop top posting)

On 4/1/2011 3:29 PM, Simon Glass wrote:
> Hi Stephen,
>
> Sorry for the confusion, but in fact I was talking about the patch to
> make ARM use the generic bug handling via an undef instruction instead
> of calling ______bug() or writing to memory address 0. Please see
> here:
>
> http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=6808/1

Yes I've seen your patch (and even posted comments on it which have not
been responded to).

Correct me if I'm wrong, but that patch with CONFIG_BUG=n would lead to
the same error that Omar is seeing because the code only modifies the
bug infrastructure when CONFIG_BUG=y.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

