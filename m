Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932293Ab0KCS2A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 14:28:00 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:61636 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755441Ab0KCS16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 14:27:58 -0400
Subject: Re: [PATCHv2 1/3] ARM: Translate delay.S into (mostly) C
From: Will Deacon <will.deacon@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Daniel Walker <dwalker@codeaurora.org>,
        Nicolas Pitre <nico@fluxnic.net>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Saravana Kannan <skannan@codeaurora.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Colin Cross <ccross@android.com>, linux-arm-kernel@lists.infradead.org
In-Reply-To: <1288300770-18350-2-git-send-email-sboyd@codeaurora.org>
References: <1288300770-18350-1-git-send-email-sboyd@codeaurora.org>
	 <1288300770-18350-2-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Nov 2010 18:27:21 +0000
Message-ID: <1288808841.23615.5.camel@e102144-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Nov 2010 18:27:25.0080 (UTC) FILETIME=[C3301980:01CB7B84]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Thu, 2010-10-28 at 21:19 +0000, Stephen Boyd wrote:
> Nico expressed concern that fixed lpj cmdlines will break due to
> compiler optimizations. That doesn't seem to be the case since
> before and after this patch I get the same lpj value when running
> my CPU at 19.2 MHz. That should be sufficiently slow enough to
> cover any machine running Linux.

I appreciate this is an exceptional case, but there are some lucky
guys at ARM who (as routinely as they can) boot Linux on sub 1MHz
hardware. The delay loop is something they're keen to avoid so they do
make use of the lpj= command line option and would rather it didn't
break on them.

Will

