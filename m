Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613Ab0EIMGJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 08:06:09 -0400
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:49750 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753147Ab0EIMGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 08:06:04 -0400
X-Greylist: delayed 481 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 May 2010 08:06:03 EDT
Subject: Re: [PATCH] backlight: l4f00242t03: Fix regulators handling code
 in remove function
From: Richard Purdie <rpurdie@rpsys.net>
To: Alberto Panizzo <maramaopercheseimorto@gmail.com>
Cc: linux-next <linux-next@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1272315068.3037.99.camel@realization>
References: <1272315068.3037.99.camel@realization>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 08 May 2010 14:39:55 +0100
Message-ID: <1273325995.4312.35.camel@rex>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-26 at 22:51 +0200, Alberto Panizzo wrote:
> Simple swap of regulator free
> 
> Signed-off-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>
> ---
>  drivers/video/backlight/l4f00242t03.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

Queued in the backlight tree, thanks!

Richard

