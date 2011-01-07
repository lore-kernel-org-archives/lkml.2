Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378Ab1AGJc0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 04:32:26 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51175 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007Ab1AGJcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 04:32:24 -0500
Date: Fri, 7 Jan 2011 09:31:55 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Hans Ulli Kroll <ulli.kroll@googlemail.com>
Cc: rtc-linux@googlegroups.com, Alessandro Zummo <a.zummo@towertech.it>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/2] ARM: Gemini: add RTC support for Gemini SoC
Message-ID: <20110107093155.GN31708@n2100.arm.linux.org.uk>
References: <1292339307-14336-1-git-send-email-ulli.kroll@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292339307-14336-1-git-send-email-ulli.kroll@googlemail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 04:08:25PM +0100, Hans Ulli Kroll wrote:
> This patch adds the driver for the rtc chip on the Gemini SoC

I'll take patch 2, but not patch 1.  There is no requirement for patch 1
to come via my tree - it can be handled by the RTC people.

My tree is not for random driver code being merged into mainline just
because it's used on some ARM platform somewhere.

(I'm making this request as a result of feedback from Linus on last nights
merge of the ARM tree.)

Thanks.
