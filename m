Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab0LQKmY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 05:42:24 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48888 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab0LQKmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 05:42:23 -0500
Subject: Re: [PATCH] regulator: Staticise non-exported functions in mc13892
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Yong Shen <yong.shen@linaro.org>, linux-kernel@vger.kernel.org
In-Reply-To: <1292513396-9874-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1292513396-9874-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Dec 2010 10:42:18 +0000
Message-ID: <1292582538.3286.1.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-16 at 15:29 +0000, Mark Brown wrote:
> No point exposing functions that aren't used elsewhere to the global
> namespace and sparse warns about doing so.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/mc13892-regulator.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)

Applied.

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

