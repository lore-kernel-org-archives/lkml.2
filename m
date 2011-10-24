Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab1JXJKw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 05:10:52 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40498 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab1JXJKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 05:10:51 -0400
Date: Mon, 24 Oct 2011 10:10:47 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sangbeom Kim <sbkim73@samsung.com>
Cc: "'Samuel Ortiz'" <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mfd: Add s5m series irq support
Message-ID: <20111024091046.GA16231@sirena.org.uk>
References: <009301cc915a$cd72d1c0$68587540$@com>
 <20111023084233.GB3135@opensource.wolfsonmicro.com>
 <009801cc9171$c4ea1970$4ebe4c50$@com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <009801cc9171$c4ea1970$4ebe4c50$@com>
X-Cookie: Pyros of the world... IGNITE !!!
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 23, 2011 at 07:51:50PM +0900, Sangbeom Kim wrote:

> I hope that this driver will be base code for regmap based irq driver
> I want discuss more detail in Prague.

FWIW I've got an interface and part of the implementation coded up
already but I've not got appropriate hardware for testing with me -
let's use that as a basis for discussion, if I've got time I might also
have the implementation implemented but not tested.
