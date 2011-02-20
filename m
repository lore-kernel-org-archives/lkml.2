Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911Ab1BTChT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 21:37:19 -0500
Received: from fifo99.com ([67.223.236.141]:46387 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754732Ab1BTChS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 21:37:18 -0500
X-Greylist: delayed 617 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Feb 2011 21:37:17 EST
Subject: Re: [PATCH] msm: headsmp.S: Fix section mismatch
From: Daniel Walker <dwalker@fifo99.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
In-Reply-To: <1298085249-10518-1-git-send-email-sboyd@codeaurora.org>
References: <1298085249-10518-1-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 19 Feb 2011 18:26:57 -0800
Message-ID: <1298168817.17118.2.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-18 at 19:14 -0800, Stephen Boyd wrote:
> WARNING: vmlinux.o(.cpuinit.text+0xc80): Section mismatch in
> reference from the function boot_secondary() to the variable
> .init.text:msm_secondary_startup
> The function __cpuinit boot_secondary() references a variable
> __init msm_secondary_startup.  If msm_secondary_startup is only
> used by boot_secondary then annotate msm_secondary_startup with
> a matching annotation.

Description is pretty gross.. Can you just explain how the section
mismatch is happening.

Daniel

