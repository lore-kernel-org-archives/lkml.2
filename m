Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab0ION51 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 09:57:27 -0400
Received: from void.printf.net ([89.145.121.20]:58964 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752344Ab0ION5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 09:57:25 -0400
Date: Wed, 15 Sep 2010 14:57:19 +0100
From: Chris Ball <cjb@laptop.org>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: linux-mmc@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc: Reduce fOD to 200 kHz if possible
Message-ID: <20100915135719.GA1677@void.printf.net>
References: <1284541140-7328-1-git-send-email-haavard.skinnemoen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284541140-7328-1-git-send-email-haavard.skinnemoen@atmel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Haavard,

On Wed, Sep 15, 2010 at 10:59:00AM +0200, Haavard Skinnemoen wrote:
> Since the identification frequency was increased to 400 kHz, my
> ATSTK1000 board has not been able to initialize any MMC or SD cards.
> Reducing the identification mode frequency to 200 kHz fixes the problem.

Good news -- there's already a patch to fix this in -mm.

Please test http://article.gmane.org/gmane.linux.kernel.commits.mm/62969
and let us know whether it works for you.

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
