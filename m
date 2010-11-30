Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab0K3PPJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 10:15:09 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64057 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab0K3PPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 10:15:08 -0500
Subject: Re: [PATCH] regulator: Copy constraints from regulators when
 initialising them
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
In-Reply-To: <1291046117-9090-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1291046117-9090-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Nov 2010 15:15:03 +0000
Message-ID: <1291130103.3293.16.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-29 at 15:55 +0000, Mark Brown wrote:
> Currently the regulator API uses the constraints structure passed in to
> the core throughout the lifetime of the object. This means that it is not
> possible to mark the constraints as __initdata so if the kernel supports
> many boards the constraints for all of them are kept around throughout the
> lifetime of the system, consuming memory needlessly. By copying constraints
> that are actually used we allow the use of __initdata, saving memory when
> multiple boards are supported.
> 
> This also means the constraints can be const.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Applied.

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

