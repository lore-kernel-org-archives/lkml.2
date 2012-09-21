Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab2IUBPo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 21:15:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40484 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab2IUBPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 21:15:43 -0400
Date: Thu, 20 Sep 2012 18:13:04 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/22] lp8727_charger: clean up code
Message-ID: <20120921011303.GA10590@lizard>
References: <A874F61F95741C4A9BA573A70FE3998F41EF1E58@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F41EF1E58@DQHE02.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2012 at 09:22:39AM +0000, Kim, Milo wrote:
> LP8727 driver should be fixed for several reasons.
> 
> (a) Need to clean up _probe() and _remove()
> (b) Not secure code when the platform data is NULL
> (c) Improved the interrupt handling
> (d) Lots of definitions should be unique.
> (e) Others...
> 
> Patch v2.
> These patches are submitted more separately.

Nice! All 22 applied, thank you so much!

Anton.
