Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934236Ab0KPKfM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 05:35:12 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:43252 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932793Ab0KPKfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 05:35:10 -0500
Date: Tue, 16 Nov 2010 11:34:18 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Wolfram Sang <w.sang@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-i2c@vger.kernel.org, Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Hans Verkuil <hverkuil@xs4all.nl>, Sergio Aguirre <saaguirre@ti.com>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Philipp Wiesner <p.wiesner@phytec.de>,
        =?ISO-8859-1?B?TeFydG9uIE7pbWV0aA==?= <nm127@freemail.hu>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: video: do not clear 'driver' from an i2c_client
Message-ID: <20101116113418.5c4ee813@endymion.delvare>
In-Reply-To: <20101115222815.GB25167@pengutronix.de>
References: <1289398455-21949-1-git-send-email-w.sang@pengutronix.de>
	<20101115222815.GB25167@pengutronix.de>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

Sorry for the late answer.

On Mon, 15 Nov 2010 23:28:15 +0100, Wolfram Sang wrote:
> On Wed, Nov 10, 2010 at 03:14:13PM +0100, Wolfram Sang wrote:
> > The i2c-core does this already.
> > 
> > Reported-by: Jean Delvare <khali@linux-fr.org>
> > Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> > ---
> > 
> > Not sure if this should go via i2c or media?
> 
> Okay, as Jean did not pick it up in his latest pull request, I guess this means
> it shall go via the media-tree? :) Mauro, will you pick it up?

Yes I think it should go through Mauro's tree. I was simply waiting for
your other patch to get merged first (which happened yesterday),
because this patch depended on that one.

So:

Acked-by: Jean Delvare <khali@linux-fr.org>

and Mauro please pick the patch in your tree.

Thanks,
-- 
Jean Delvare
