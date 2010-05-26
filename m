Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934271Ab0EZLbz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 07:31:55 -0400
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:60310 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932077Ab0EZLby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 07:31:54 -0400
Subject: Re: [PATCH v2] leds-lp3944: properly handle lp3944_configure fail
 in lp3944_probe
From: Richard Purdie <rpurdie@rpsys.net>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       Wolfram Sang <w.sang@pengutronix.de>
In-Reply-To: <20100517121525.c895d8d9.ospite@studenti.unina.it>
References: <1274089668.28623.3.camel@mola>
	 <20100517121525.c895d8d9.ospite@studenti.unina.it>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 May 2010 12:31:31 +0100
Message-ID: <1274873491.16229.84.camel@rex>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-17 at 12:15 +0200, Antonio Ospite wrote:
> On Mon, 17 May 2010 17:47:48 +0800
> Axel Lin <axel.lin@gmail.com> wrote:
> 
> > In current implementation, lp3944_probe return 0 even if lp3944_configure fail.
> > Therefore, led_classdev_unregister will be executed twice
> > ( in error handling of lp3944_configure and lp3944_remove ).
> > This patch properly handles lp3944_configure fail in lp3944_probe.
> > 
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> 
> Acked-by: Antonio Ospite <ospite@studenti.unina.it>
> 

Queued in the leds tree, thanks.

Richard

