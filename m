Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419Ab0LMOlQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 09:41:16 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63722 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab0LMOlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 09:41:14 -0500
Subject: Re: [PATCH] regulator: Call into regulator driver only when
 voltage min/max really changes.
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1292151342-12970-1-git-send-email-skannan@codeaurora.org>
References: <1292151342-12970-1-git-send-email-skannan@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Dec 2010 14:41:10 +0000
Message-ID: <1292251270.3320.79.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-12-12 at 02:55 -0800, Saravana Kannan wrote:
> Even in cases where the consumer driver calls the regulator core with
> different voltage min/max values, the application of the various
> voltage constraints could result in the min/max voltage values passed
> to the regulator driver to be unchanged since the previous invocation.
> 
> Optimize these cases by not calling into the regulator driver and not
> sending incorrect/unnecessary voltage change notifications.
> 
> Signed-off-by: Saravana Kannan <skannan@codeaurora.org>

This doesn't apply. Any chance you could regenerate against the
regulator for-next branch ?

Thanks

Liam  
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

