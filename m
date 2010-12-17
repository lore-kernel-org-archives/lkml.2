Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116Ab0LQKmn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 05:42:43 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48888 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667Ab0LQKmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 05:42:42 -0500
Subject: Re: [PATCH] regulator: Only notify voltage changes when they
 succeed
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Saravana Kannan <skannan@codeaurora.org>, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
In-Reply-To: <1292507950-8288-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1292507950-8288-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Dec 2010 10:42:27 +0000
Message-ID: <1292582547.3286.2.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-16 at 13:59 +0000, Mark Brown wrote:
> Currently we notify a voltage change whenever we exit set_voltage(),
> even if the change failed for some reason (eg, a constraints issue).
> This shouldn't cause any substantial ill effects but is wasteful as
> listeners get notified on noops. Fix this by moving the notification
> into _do_set_voltage() and only notifying if we don't return an error.
> 
> Reported-by: Saravana Kannan <skannan@codeaurora.org>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/core.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
Applied.

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

