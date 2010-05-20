Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900Ab0ETQXi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 12:23:38 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56037 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628Ab0ETQXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 12:23:35 -0400
Date: Thu, 20 May 2010 17:23:33 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Dajun Chen <Dajun.Chen@diasemi.com>
Cc: linux-kernel@vger.kernel.org, Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] GPIO of DA9052 Linux device drivers (2/9)
Message-ID: <20100520162333.GA3597@sirena.org.uk>
References: <3495EC08FA53E94AAA00CC4743D5BA7E010C20EF@pandora.diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3495EC08FA53E94AAA00CC4743D5BA7E010C20EF@pandora.diasemi.com>
X-Cookie: Because the wine remembers.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 10:28:22AM +0100, David Dajun Chen wrote:

> The attached is the GPIO part of the device drivers newly developed for DA9052 Power Management IC from Dialog Semiconductor.

While there is some gpiolib functionality in this code there is also
substantial additional functionality implementing non-stnadard APIs
which appear to mostly replicate existing kernel functionality.  As I
said in reply to the regulator driver I'd strongly suggest comparing the
driver with other drivers for similar devices and if you're producing
something that looks substantially different to those drivers really
reexamining in detail why your driver is different and if it should be.
