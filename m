Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681Ab2LQG7C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 01:59:02 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39327 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab2LQG67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 01:58:59 -0500
Date: Sun, 16 Dec 2012 22:55:34 -0800
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Tony Lindgren <tony@atomide.com>
Cc: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        Joerg Reisenweber <joerg@openmoko.org>,
        Ivaylo Dimitrov <freemangordon@abv.bg>, linux-omap@vger.kernel.org
Subject: Re: [PATCH v2] New Nokia RX-51 power supply battery driver
Message-ID: <20121217065135.GA18301@lizard.gateway.2wire.net>
References: <19040462.WFXWijAIDd@pali>
 <2562836.SjVVyiPAk1@pali>
 <20121118231239.GC29066@lizard.sbx05977.paloaca.wayport.net>
 <5320319.2WmO5VDT8j@pali>
 <20121119182002.GA2670@lizard>
 <20121121192042.GG18567@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121121192042.GG18567@atomide.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 11:20:43AM -0800, Tony Lindgren wrote:
> * Anton Vorontsov <cbouatmailru@gmail.com> [121119 10:25]:
> > On Mon, Nov 19, 2012 at 01:18:29PM +0100, Pali Rohár wrote:
> > [...] 
> > > Ok. Here is missing patch which register this driver in Nokia N900 board code. Without it driver is not loaded.
> > 
> > Cc'ing OMAP folks.
> 
> Looks OK to me queue with the other patches in the series:
> 
> Acked-by: Tony Lindgren <tony@atomide.com>

Applied, thanks!

(I'll make a second pull request for this window, but no sure if it will
make it. We will see.)

Thanks,
Anton
