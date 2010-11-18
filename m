Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555Ab0KRN3c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 08:29:32 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52029 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754900Ab0KRN3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 08:29:31 -0500
Date: Thu, 18 Nov 2010 13:29:29 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Joe Perches <joe@perches.com>
Cc: Daniel Walker <dwalker@codeaurora.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        bleong@codeaurora.org
Subject: Re: [PATCH 2/2] drivers: regulator: core: convert to using pr_
 macros
Message-ID: <20101118132929.GD7233@rakim.wolfsonmicro.main>
References: <1290036628-9928-1-git-send-email-dwalker@codeaurora.org>
 <1290036628-9928-2-git-send-email-dwalker@codeaurora.org>
 <1290040611.28741.332.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290040611.28741.332.camel@Joe-Laptop>
X-Cookie: Pass with care.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 04:36:51PM -0800, Joe Perches wrote:

> (rest of original patch below, but no additional comments)

Don't do that, trim unneeded context from your mails.  This makes it
much easier to find the actual content you've written and is much nicer
for those of us who work on mobile connections.
