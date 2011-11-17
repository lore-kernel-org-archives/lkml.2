Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918Ab1KQAL4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 19:11:56 -0500
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:54043 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754757Ab1KQALy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 19:11:54 -0500
From: Kevin Hilman <khilman@ti.com>
To: Thomas Weber <weber@corscience.de>
Cc: tony@atomide.com,
        Russell King <linux@arm.linux.org.uk> (maintainer:ARM PORT),
        linux-omap@vger.kernel.org (open list:OMAP SUPPORT),
        linux-arm-kernel@lists.infradead.org (open list:ARM PORT),
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH Resend] ARM: OMAP2+: Remove empty io.h
Organization: Texas Instruments, Inc.
References: <1321459012-15418-1-git-send-email-weber@corscience.de>
Date: Wed, 16 Nov 2011 16:11:50 -0800
In-Reply-To: <1321459012-15418-1-git-send-email-weber@corscience.de> (Thomas
	Weber's message of "Wed, 16 Nov 2011 16:56:52 +0100")
Message-ID: <87d3cr620p.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Weber <weber@corscience.de> writes:

> The file arch/arm/mach-omap2/io.h is empty, so we can remove it.
>
> Signed-off-by: Thomas Weber <weber@corscience.de>

It's empty and unused elsewhere.

Acked-by: Kevin Hilman <khilman@ti.com>
