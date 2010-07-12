Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab0GLKks (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 06:40:48 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48318 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751668Ab0GLKkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 06:40:47 -0400
Date: Mon, 12 Jul 2010 11:40:45 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sekhar Nori <nsekhar@ti.com>
Cc: linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com,
        Anuj Aggarwal <anuj.aggarwal@ti.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH 1/2] regulator: tps6507x: allow driver to use
 DEFDCDC{2,3}_HIGH register
Message-ID: <20100712104045.GE21840@rakim.wolfsonmicro.main>
References: <1278930888-26810-1-git-send-email-nsekhar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278930888-26810-1-git-send-email-nsekhar@ti.com>
X-Cookie: Do I have a lifestyle yet?
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 12, 2010 at 04:04:46PM +0530, Sekhar Nori wrote:

> +
> +	/* Does DCDC high or the low register defines output voltage? */
> +	bool defdcdc_high;

This should probably be "defdcdc_default" or something.  Presumably the
line can also be wired to a GPIO and changed at runtime (otherwise the
feature seems at best odd) and if support for that is implemented then
this will change from being a static configuration in the platform data
to something configured dynamically so the name would no longer make
sense.
