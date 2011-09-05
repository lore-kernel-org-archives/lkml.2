Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678Ab1IETyQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 15:54:16 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:51893 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753087Ab1IETyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 15:54:12 -0400
Message-ID: <4E6528CD.7080003@metafoo.de>
Date: Mon, 05 Sep 2011 21:53:49 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110818 Icedove/3.0.11
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regmap: Fix regmap compilation with CONFIG_DEBUGFS=n
References: <1315250978-4242-1-git-send-email-lars@metafoo.de> <20110905194254.GA11107@opensource.wolfsonmicro.com>
In-Reply-To: <20110905194254.GA11107@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2011 09:42 PM, Mark Brown wrote:
> On Mon, Sep 05, 2011 at 09:29:38PM +0200, Lars-Peter Clausen wrote:
>> With CONFIG_DEBUGFS disabled the regmap compilation fails with the following
>> errors:
> 
>> 	drivers/base/regmap/regcache.o: In function `regmap_debugfs_initcall':
>> 	drivers/base/regmap/internal.h:96: multiple definition of `regmap_debugfs_initcall'
>> 	drivers/base/regmap/regmap.o:drivers/base/regmap/internal.h:96: first defined here
>> 	drivers/base/regmap/regcache.o: In function `regmap_debugfs_init':
> 
> I sense that this doesn't actually happen in mainline...

Uhm, yes... the patch is still valid though, want me to resubmit it with a
different patch description?
