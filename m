Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536Ab1BBUK1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 15:10:27 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37668 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752262Ab1BBUK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 15:10:26 -0500
Date: Wed, 2 Feb 2011 20:10:24 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: Build regressions/improvements in v2.6.38-rc3
Message-ID: <20110202201023.GC28705@opensource.wolfsonmicro.com>
References: <alpine.DEB.2.00.1102021504550.31867@ayla.of.borg>
 <20110202144924.GD9810@sirena.org.uk>
 <AANLkTindwELkXft9phmiaduyB5icMCbAorbKxZMYP2bw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTindwELkXft9phmiaduyB5icMCbAorbKxZMYP2bw@mail.gmail.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 02, 2011 at 03:06:53PM -0500, Arnaud Lacombe wrote:

> if CONFIG_BUG has been set to "n", it _will_ return. It could have
> been made to trigger a crash, but it did not, on purpose.

Oh no, not another one :(
