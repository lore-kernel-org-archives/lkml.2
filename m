Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab0LJWNy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 17:13:54 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56507 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab0LJWNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 17:13:53 -0500
Subject: Re: [PATCH 1/3] regulator: Use _regulator_get_voltage()
 consistently
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1292002088-9644-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1292002088-9644-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Dec 2010 22:13:47 +0000
Message-ID: <1292019227.3422.14.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-10 at 17:28 +0000, Mark Brown wrote:
> Rather than referencing the get_voltage() operation directly in the
> ops struct use the internal _regulator_get_voltage() API call to do
> so, facilitating refactoring.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

All Applied.

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

