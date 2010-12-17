Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350Ab0LQKmq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 05:42:46 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48888 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667Ab0LQKmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 05:42:44 -0500
Subject: Re: [PATCH 1/2] regulator: Add API to re-apply voltage to hardware
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Saravana Kannan <skannan@codeaurora.org>, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
In-Reply-To: <1292514577-13144-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1292514577-13144-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Dec 2010 10:42:41 +0000
Message-ID: <1292582561.3286.3.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-16 at 15:49 +0000, Mark Brown wrote:
> When cooperating with an external control source the regulator setup
> may be changed underneath the API. Currently consumers can just redo
> the regulator_set_voltage() to restore a previously set configuration
> but provide an explicit API for doing this as optimsations in the
> regulator_set_voltage() implementation will shortly prevent that.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---

Both Applied.

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

