Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab0IEIrK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 04:47:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46515 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753470Ab0IEIrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 04:47:09 -0400
Date: Sun, 5 Sep 2010 09:47:07 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Rhyland Klein <rklein@nvidia.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "olof@lixom.net" <olof@lixom.net>, Andrew Chew <AChew@nvidia.com>,
        "khali@linux-fr.org" <khali@linux-fr.org>
Subject: Re: [PATCH v2] power supply: add driver for TI BQ20Z75 gas gauge IC
Message-ID: <20100905084707.GA24817@opensource.wolfsonmicro.com>
References: <1283448586-14613-1-git-send-email-rklein@nvidia.com> <20100902174736.GA28649@oksana.dev.rtsoft.ru> <E88A1D35AF5437468E5B14C7C4BA61C702CF4B651C@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E88A1D35AF5437468E5B14C7C4BA61C702CF4B651C@HQMAIL01.nvidia.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 04, 2010 at 02:00:47PM -0700, Rhyland Klein wrote:

> Mark, have you had a chance to double check my changes based on the comments you made? 

Yes: http://lkml.org/lkml/2010/9/3/136
