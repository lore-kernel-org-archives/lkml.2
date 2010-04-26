Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab0DZOuY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 10:50:24 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:53199 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab0DZOuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 10:50:22 -0400
Subject: Re: [PATCH] regulator: Allow regulator-regulator supplies to be
 specified by name
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1272291494-31682-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1272291494-31682-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Apr 2010 15:50:16 +0100
Message-ID: <1272293416.3208.75.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-26 at 15:18 +0100, Mark Brown wrote:
> When one regulator supplies another allow the relationship to be specified
> using names rather than struct regulators, in a similar manner to that
> allowed for consumer supplies. This allows static configuration at compile
> time, reducing the need for dynamic init code.
> 
> Also change the references to LINE supply to be system supply since line
> is sometimes used for actual supplies and therefore potentially confusing.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Applied.

Thanks

Liam

-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

