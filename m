Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873Ab2EJJMc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 05:12:32 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:35707 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757639Ab2EJJMa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 05:12:30 -0400
MIME-Version: 1.0
In-Reply-To: <20120502095311.GZ24211@n2100.arm.linux.org.uk>
References: <1335935266-25289-1-git-send-email-thomas.abraham@linaro.org>
	<1335935266-25289-2-git-send-email-thomas.abraham@linaro.org>
	<20120502095311.GZ24211@n2100.arm.linux.org.uk>
Date: Thu, 10 May 2012 14:42:30 +0530
Message-ID: <CAJuYYwSJ8FBQiykcyym9Gg1jVoW+rGZmjtHfy4zgcDEX6edOEA@mail.gmail.com>
Subject: Re: [PATCH 1/7] mmc: dw_mmc: lookup for optional biu and ciu clocks
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-mmc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-samsung-soc@vger.kernel.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, kgene.kim@samsung.com, cjb@laptop.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 May 2012 15:23, Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> On Tue, May 01, 2012 at 10:07:40PM -0700, Thomas Abraham wrote:
>> Some platforms allow for clock gating and control of bus interface unit clock
>> and card interface unit clock. Add support for clock lookup of optional biu
>> and ciu clocks for clock gating and clock speed determination.
>
> As we're moving progressively towards the common clk API, which requires
> the new clk_prepare/clk_unprepare calls, new code should be using the
> dated API.  Please update this to do so (eg, by using clk_prepare_enable()
> instead of clk_enable() for the simple solution.)  Better solutions
> involve decoupling the two and only using clk_enable()/clk_disable() where
> you really need the clock to be on.

Thanks for your suggestion. I will modify this to use the
clk_prepare_enable and clk_disable_unprepare calls for now.

Thanks,
Thomas.
