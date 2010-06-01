Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717Ab0FAO0B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 10:26:01 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45753 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756379Ab0FAO0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 10:26:00 -0400
Date: Tue, 1 Jun 2010 15:25:58 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
       uclinux-dist-devel@blackfin.uclinux.org,
       Sonic Zhang <sonic.zhang@analog.com>
Subject: Re: [PATCH 2/2] regulator: new driver for the AD12{2,3,4,5},
 AD150, and AD5022 parts
Message-ID: <20100601142558.GD863@rakim.wolfsonmicro.main>
References: <1275399239-6788-1-git-send-email-vapier@gentoo.org>
 <1275399239-6788-2-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275399239-6788-2-git-send-email-vapier@gentoo.org>
X-Cookie: Some settling may occur.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 01, 2010 at 09:33:59AM -0400, Mike Frysinger wrote:

> With userspace consumer enabled, power devices with only one switch
> PIN connect to GPIO port can be enabled and disable via sysfs interface.

This looks exactly like a fixed voltage regualtor except there is no
facility for reporting the voltage.  Why is a new driver being supplied?
