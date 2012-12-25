Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab2LYAis (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 19:38:48 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:61772 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377Ab2LYAiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 19:38:46 -0500
MIME-Version: 1.0
In-Reply-To: <20121224163449.GY30837@opensource.wolfsonmicro.com>
References: <1355794210.5681.1.camel@phoenix>
	<20121224163449.GY30837@opensource.wolfsonmicro.com>
Date: Tue, 25 Dec 2012 08:38:45 +0800
Message-ID: <CAN1soZzsSy2MayHHRdSK2Ud0jyn+tarH_7x+AHPhfdztxZGhsw@mail.gmail.com>
Subject: Re: [PATCH 1/4] regulator: core: Allow specify apply_[reg|bit] for
 regmap based voltage_sel operations
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Axel Lin <axel.lin@ingics.com>, David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Mike Rapoport <mike@compulab.co.il>, Liam Girdwood <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 25, 2012 at 12:34 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Tue, Dec 18, 2012 at 09:30:10AM +0800, Axel Lin wrote:
>> Some DVM regulators needs to update apply_bit after setting vsel_reg to
>> initiate voltage change on the output.  This patch adds apply_reg and
>
> Applied all except patch 2 (where you've done a new version, I'll wait
> for Haojian to ack though) - thanks!

I acked 2nd patch just now.

Best Regards
Haojian
