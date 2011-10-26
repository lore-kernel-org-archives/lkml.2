Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab1JZFZ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 01:25:27 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46995 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697Ab1JZFZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 01:25:25 -0400
MIME-Version: 1.0
X-Originating-IP: [85.13.70.251]
In-Reply-To: <20111026051604.GT2638@game.jcrosoft.org>
References: <1319536106-25802-1-git-send-email-ohad@wizery.com>
 <1319536106-25802-2-git-send-email-ohad@wizery.com> <20111026051604.GT2638@game.jcrosoft.org>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 26 Oct 2011 07:25:03 +0200
Message-ID: <CAK=WgbaLcjnc1ApSwJ0zeTdjJpQzAnhYUZZ-kdtSKsHJun+FkQ@mail.gmail.com>
Subject: Re: [PATCH 1/7] amp/remoteproc: add framework for controlling remote processors
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Tony Lindgren <tony@atomide.com>, Brian Swetland <swetland@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>, Greg KH <greg@kroah.com>,
        akpm@linux-foundation.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 26, 2011 at 7:16 AM, Jean-Christophe PLAGNIOL-VILLARD > On
STM Soc > you can upload the firmware code where you want
> the you just have to specify in 2 register where the entry point of the co-pro

great, can you provide more info ? are you using an iommu ?

> BTW do you plan to support CMA as a lot of copro will request a big
> contineuous memory to work on between the cpus.

sure, this patch set is already using CMA.

> I've to go to the ELCE will continue the review later

come to "Tycho" today at 11:45 :)

Thanks,
Ohad.
