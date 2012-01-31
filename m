Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879Ab2AaKoZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 05:44:25 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:65019 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774Ab2AaKoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 05:44:22 -0500
MIME-Version: 1.0
In-Reply-To: <1327992241.9257.1.camel@phoenix>
References: <1327992241.9257.1.camel@phoenix>
Date: Tue, 31 Jan 2012 02:44:21 -0800
X-Google-Sender-Auth: xZA_gc9P5GSp5RZalC55Kk2XuVU
Message-ID: <CAOS58YMNBLFJtYRPBXSFtat4wJb_jMGhKa1OnxFP=wqGpz0kdg@mail.gmail.com>
Subject: Re: [PATCH] Documentation: devres: add devm_regulator_* to the list
 of managed interfaces
From: Tejun Heo <tj@kernel.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 10:44 PM, Axel Lin <axel.lin@gmail.com> wrote:
> Add devm_regulator_put() and devm_regulator_bulk_get() to the list of managed
> interfaces.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thank you.

-- 
tejun
