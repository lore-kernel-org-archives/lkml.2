Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090Ab2C0AxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 20:53:19 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:52987 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755269Ab2C0Awq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 20:52:46 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20120326175029.GJ3789@opensource.wolfsonmicro.com>
References: <1332457828.9382.0.camel@phoenix> <20120326175029.GJ3789@opensource.wolfsonmicro.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Tue, 27 Mar 2012 08:52:25 +0800
Message-ID: <CAF+7xWnrY5jjznuJyNFA-CNpnrdpnX9kVS1myq1PzAXEmCGdWA@mail.gmail.com>
Subject: Re: [PATCH 1/2] regulator: Convert tps6524x to set_voltage_sel
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Cyril Chemparathy <cyril@ti.com>,
        Liam Girdwood <lrg@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/3/27 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Fri, Mar 23, 2012 at 07:10:28AM +0800, Axel Lin wrote:
>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
>
> These don't apply any more due to some of your other cleanups which got
> applied first, can you rebase please?

Hi Mark,
I tried to apply both patch to linux-next (20120326) and it looks ok.
I checked you tree and found:
Both patch are appliable to your topic/drivers branch but failed to apply
to your for-next branch.
It is because commit f03570cf "regulator: Fix setting selector in
tps6524x set_voltage function" is missing from your for-next branch. (
Note this commit already in Linus' tree, so I don't think I should
re-generate the patch against your for-next branch.)

I'm not sure if you still keep both patches, if a resend is required,
just let me know.

Thanks,
Axel
