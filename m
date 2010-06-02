Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab0FBKef (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 06:34:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51861 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750749Ab0FBKee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 06:34:34 -0400
Date: Wed, 2 Jun 2010 11:34:45 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: sonic zhang <sonic.adi@gmail.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>
Subject: Re: [PATCH v3] regulator: new drivers for AD5398 and AD5821
Message-ID: <20100602103444.GB2457@opensource.wolfsonmicro.com>
References: <1275474940.2640.2.camel@eight.analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275474940.2640.2.camel@eight.analog.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 06:35:40PM +0800, sonic zhang wrote:

> The AD5398 and AD5821 are single 10-bit DAC with 120 mA output current
> sink capability. They feature an internal reference and operates from
> a single 2.7 V to 5.5 V supply.

> This driver supports both the AD5398 and the AD5821.  It adapts into the
> voltage and current framework.

The issues in the mail I just sent for your v2 patch also apply here.
