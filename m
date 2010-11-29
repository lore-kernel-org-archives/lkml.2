Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab0K2WAh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 17:00:37 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60709 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751806Ab0K2WAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 17:00:36 -0500
Date: Mon, 29 Nov 2010 22:00:46 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Joe Perches <joe@perches.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: Add and use rdev_<level> macros
Message-ID: <20101129220046.GB8335@opensource.wolfsonmicro.com>
References: <9c7b69e9a5274587e5ba9f2b460f79f0159e9b75.1291060462.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c7b69e9a5274587e5ba9f2b460f79f0159e9b75.1291060462.git.joe@perches.com>
X-Cookie: You enjoy the company of other people.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 11:54:50AM -0800, Joe Perches wrote:

> +#define rdev_debug(rdev, fmt, ...)					\
> +	pr_debug("%s: " fmt, rdev_get_name(rdev), ##__VA_ARGS__)
> +

This looks good but I'd prefer if this were rdev_dbg() rather than
rdev_debug() to match dev_dbg() - it feels like that would be a better
match given that we're supplying an rdev and it's less typing to boot.
