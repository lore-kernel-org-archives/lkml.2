Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978Ab2GKOWZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 10:22:25 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:62952 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757952Ab2GKOWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 10:22:23 -0400
Message-Id: <201207111421.q6BELFoF006060@sw-eng-lt-dc-vm2>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
From: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
CC: Liam Girdwood <lrg@ti.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: Fix bug in regulator_mode_to_status() core function.
References: <201207111221.q6BCLW8L014872@sw-eng-lt-dc-vm2>
	<20120711132655.GG3938@opensource.wolfsonmicro.com>
In-Reply-To: <20120711132655.GG3938@opensource.wolfsonmicro.com>
Date: Wed, 11 Jul 2012 15:18:00 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
> Sent: 11 July 2012 14:29
> 
> On Wed, Jul 11, 2012 at 01:10:01PM +0100, Krystian Garbaciak wrote:
> > Fix typo for case REGULATOR_STATUS_STANDBY -> REGULATOR_MODE_STANDBY.
> > For undefined mode, return REGULATOR_STATUS_ERROR (0 is not valid status).
> 
> This is deliberate.  It's not reporting an error, it's reporting an
> indeterminate status which is a different thing.

Ok, then I would propose to use REGULATOR_STATUS_OFF instead of 0, to present
your deliberate decision here.

