Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650Ab0K3LOA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 06:14:00 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33080 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752228Ab0K3LN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 06:13:58 -0500
Date: Tue, 30 Nov 2010 11:13:55 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Wan ZongShun <mcuos.com@gmail.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org
Subject: Re: [RFC][PATCH 4/5] ASoC: Fix missing spin_unlock_irqrestore
Message-ID: <20101130111354.GC7403@rakim.wolfsonmicro.main>
References: <1291023491.22911.1.camel@mola>
 <1291023767.22911.9.camel@mola>
 <20101129114700.GP30360@rakim.wolfsonmicro.main>
 <AANLkTinks9Msj11mfJSO9Ezwt179JYkxNKFD3dAp=X+X@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinks9Msj11mfJSO9Ezwt179JYkxNKFD3dAp=X+X@mail.gmail.com>
X-Cookie: To teach is to learn.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 09:36:29AM +0800, Wan ZongShun wrote:

> I have tested it.

> Thanks!
> Acked-by: Wan ZongShun <mcuos.com@gmail.com>

Excellent, applied now - thanks to both of you!
