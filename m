Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233Ab1F3F5a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 01:57:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36663 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751579Ab1F3F5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 01:57:25 -0400
Date: Wed, 29 Jun 2011 22:57:20 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: myungjoo.ham@gmail.com
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Donggeun Kim <dg77.kim@samsung.com>
Subject: Re: [PATCH 3/3] MFD: MAX8997: IRQ definition moved to public header.
Message-ID: <20110630055719.GA930@opensource.wolfsonmicro.com>
References: <1309397507-24959-1-git-send-email-myungjoo.ham@samsung.com>
 <1309397507-24959-3-git-send-email-myungjoo.ham@samsung.com>
 <20110630052808.GA796@opensource.wolfsonmicro.com>
 <BANLkTikGR-HdVZ-5h3kW64wiFduuuiU6Vw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikGR-HdVZ-5h3kW64wiFduuuiU6Vw@mail.gmail.com>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 02:56:27PM +0900, MyungJoo Ham wrote:

> In order to request MAX8997's IRQs, these IRQ enums are required by
> board files (such as /arch/arm/mach-exynos4/mach-*.c). So, these IRQ
> enums are no more "private" to max8997 device drivers. Without this
> patch, board files need to include max8997-private.h.

Why does the board file need to request these IRQs?
