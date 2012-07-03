Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933531Ab2GCXG5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 19:06:57 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40068 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933064Ab2GCXG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 19:06:56 -0400
Date: Wed, 4 Jul 2012 00:06:54 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: Fix recursive mutex lockdep warning
Message-ID: <20120703230654.GD11368@opensource.wolfsonmicro.com>
References: <1341282066-15325-1-git-send-email-sboyd@codeaurora.org> <20120703192652.GH29030@opensource.wolfsonmicro.com> <4FF3514E.6050401@codeaurora.org> <20120703224316.GB11368@opensource.wolfsonmicro.com> <4FF3769A.3090703@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FF3769A.3090703@codeaurora.org>
X-Cookie: You will be divorced within a year.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2012 at 03:47:54PM -0700, Stephen Boyd wrote:
> On 07/03/12 15:43, Mark Brown wrote:

> >> What do you think about removing the locking in get_voltage? Is that better?
> > There's already an unlocked version of get_voltage()?

> Yes, I'm suggesting we just use that unlocked version for all of the
> code that gets the input voltage.

Either way works.
