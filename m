Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599Ab0KRNaf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 08:30:35 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50691 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754900Ab0KRNae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 08:30:34 -0500
Date: Thu, 18 Nov 2010 13:30:33 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Joe Perches <joe@perches.com>
Cc: Daniel Walker <dwalker@codeaurora.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        bleong@codeaurora.org
Subject: Re: [PATCH 2/2] drivers: regulator: core: convert to using pr_
 macros
Message-ID: <20101118133033.GE7233@rakim.wolfsonmicro.main>
References: <1290036628-9928-1-git-send-email-dwalker@codeaurora.org>
 <1290036628-9928-2-git-send-email-dwalker@codeaurora.org>
 <1290040611.28741.332.camel@Joe-Laptop>
 <1290043807.28741.334.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290043807.28741.334.camel@Joe-Laptop>
X-Cookie: Pass with care.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 05:30:07PM -0800, Joe Perches wrote:

> Perhaps something like this:

This looks reasonable, please rebase on top of Daniel's patches and
submit it properly (with changelog and so on).
