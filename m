Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258Ab0LVW0j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 17:26:39 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44948 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841Ab0LVW0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 17:26:37 -0500
Subject: Re: [PATCH] regulator: Add initial per-regulator debugfs support
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Brandon Leong <bleong@codeaurora.org>
In-Reply-To: <1292975371-32233-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <>
	 <1292975371-32233-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Dec 2010 22:26:32 +0000
Message-ID: <1293056792.3329.52.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-21 at 23:49 +0000, Mark Brown wrote:
> We only expose the use and open counts to userspace, providing a tiny
> bit of insight into what the API is up to.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
> 
> This is clearly a completely different tack to Brandon's patches in
> terms of content but it does expose a bit of the internals like I was
> talking about in review of those patches and it gets the basic debugfs
> setup stuff done so we don't need to re-review that.
> 
>  drivers/regulator/core.c         |   35 +++++++++++++++++++++++++++++++++++
>  include/linux/regulator/driver.h |    8 ++++++--
>  2 files changed, 41 insertions(+), 2 deletions(-)
> 

Applied.

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

