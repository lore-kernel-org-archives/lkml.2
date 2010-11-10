Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915Ab0KJVUS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 16:20:18 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54568 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756598Ab0KJVUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 16:20:17 -0500
Subject: Re: [PATCH 1/2] regulator: Report actual configured voltage to
 set_voltage()
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
In-Reply-To: <1289399910-7779-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1289399910-7779-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Nov 2010 21:20:08 +0000
Message-ID: <1289424008.3284.57.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-10 at 14:38 +0000, Mark Brown wrote:
> Change the interface used by set_voltage() to report the selected value
> to the regulator core in terms of a selector used by list_voltage().
> This allows the regulator core to know the voltage that was chosen
> without having to do an explict get_voltage(), which would be much more
> expensive as it will generally access hardware.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Both Applied.

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

