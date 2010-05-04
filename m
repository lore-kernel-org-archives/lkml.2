Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932837Ab0EDO4Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 10:56:16 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55798 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932366Ab0EDO4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 10:56:14 -0400
Date: Tue, 4 May 2010 15:56:20 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Marek Vasut <marek.vasut@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Remove tosa_battery driver (was: Re: [PATCH]
 tosa_battery: fix FTBFS bug due to driver_data access)
Message-ID: <20100504145620.GD3651@opensource.wolfsonmicro.com>
References: <1272374302-9506-1-git-send-email-dbaryshkov@gmail.com>
 <20100427154835.27bdc233.akpm@linux-foundation.org>
 <20100430181349.GA1015@oksana.dev.rtsoft.ru>
 <g2qbc64b4641004301340h3c942f3cn40de735b419b8535@mail.gmail.com>
 <20100502201202.GA18647@oksana.dev.rtsoft.ru>
 <r2pbc64b4641005021352ub65dd07et6c96dfba76dc5103@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <r2pbc64b4641005021352ub65dd07et6c96dfba76dc5103@mail.gmail.com>
X-Cookie: Snow Day -- stay home.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 03, 2010 at 12:52:48AM +0400, Dmitry Eremin-Solenikov wrote:
> On Mon, May 3, 2010 at 12:12 AM, Anton Vorontsov <cbouatmailru@gmail.com> wrote:

> > Eh. I see, thanks for making this clear. I added some changelog
> > and applied the following patch to battery-2.6.git:

> Thank you. Merging these two drivers is on my goal list, but it won't
> come in the near future.

TBH I'm not entirely sure it's worth it - I'd be somewhat surprised to
see users outside of tosa for the more complex functionality.
