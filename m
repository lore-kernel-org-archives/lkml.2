Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469Ab0KIPNo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 10:13:44 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44610 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751318Ab0KIPNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 10:13:42 -0500
Date: Tue, 9 Nov 2010 15:13:47 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mattias Wallin <mattias.wallin@stericsson.com>
Subject: Re: [PATCH] regulator: enable supply regulator only when use count
 is zero
Message-ID: <20101109151346.GA746@opensource.wolfsonmicro.com>
References: <1289314226-986-1-git-send-email-bengt.g.jonsson@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289314226-986-1-git-send-email-bengt.g.jonsson@stericsson.com>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 03:50:26PM +0100, Bengt Jonsson wrote:
> Supply regulators are disabled only when the last
> reference count is removed on the child regulator
> (the use count goes from 1 to 0). This patch changes
> the behaviour of enable so the supply regulator is
> enabled only when the use count of the child
> regulator goes from 0 to 1.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

> Change-Id: Ic322801119fefaabc1ed4fef248e463e67fb1857

Don't do this on mainline submissions.
