Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab1BBOt0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 09:49:26 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40628 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101Ab1BBOtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 09:49:25 -0500
Date: Wed, 2 Feb 2011 14:49:24 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: Build regressions/improvements in v2.6.38-rc3
Message-ID: <20110202144924.GD9810@sirena.org.uk>
References: <alpine.DEB.2.00.1102021504550.31867@ayla.of.borg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1102021504550.31867@ayla.of.borg>
X-Cookie: 1 bulls, 3 cows.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 02, 2011 at 03:05:16PM +0100, Geert Uytterhoeven wrote:

> 	src/drivers/regulator/wm831x-dcdc.c: warning: control reaches end of non-void function: 124 => 

Either your compiler or architecture isn't noticing that BUG() can't
return.
