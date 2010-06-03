Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab0FCX7m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 19:59:42 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55640 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753970Ab0FCX7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 19:59:41 -0400
Subject: Re: [RFC][PATCH 20/26] alsa: ASoC: Add JZ4740 codec driver
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <4C084155.5010503@metafoo.de> (sfid-20100604_005758_018873_5A725743)
Date: Fri, 4 Jun 2010 00:59:38 +0100
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
       alsa-devel@alsa-project.org
Content-Transfer-Encoding: 7bit
Message-Id: <BBE59890-DD9C-4B62-AB74-87764381D38E@opensource.wolfsonmicro.com>
References: <1275505397-16758-1-git-send-email-lars@metafoo.de> <1275505950-17334-4-git-send-email-lars@metafoo.de> <20100603174953.GH2762@rakim.wolfsonmicro.main> <4C084155.5010503@metafoo.de> (sfid-20100604_005758_018873_5A725743)
To: Lars-Peter Clausen <lars@metafoo.de>
X-Mailer: Apple Mail (2.1078)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 Jun 2010, at 00:57, Lars-Peter Clausen wrote:

> Mark Brown wrote:
> Uhm, actually this code path is taken when switching from _OFF to
> another state. If it is guaranteed that _OFF is always followed by a
> certain other state I could put the reset code in its part of the switch
> statement.

The only possible transitions are OFF <-> STANDBY <-> PREPARE <-> ON
