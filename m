Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab2AQQ6u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 11:58:50 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43193 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754434Ab2AQQ6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 11:58:49 -0500
Date: Tue, 17 Jan 2012 16:58:46 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH] regulator: Add devm_regulator_get()
Message-ID: <20120117165846.GL2944@opensource.wolfsonmicro.com>
References: <1326771598-28124-1-git-send-email-sboyd@codeaurora.org>
 <20120117110454.GD2944@opensource.wolfsonmicro.com>
 <4F15A7D0.1010901@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F15A7D0.1010901@codeaurora.org>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 08:54:40AM -0800, Stephen Boyd wrote:
> On 01/17/12 03:04, Mark Brown wrote:

> > Oh, and it's not obvious from the diff but blank lines please like the
> > adjacent code.

> Should I resend or are you ok with adding the newline there yourself?

I fixed that and also added some missing braces.
