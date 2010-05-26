Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934370Ab0EZKz0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 06:55:26 -0400
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:59853 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932077Ab0EZKzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 06:55:25 -0400
Subject: Re: [PATCH] backlight: adp8860: add support for ADP8861 & ADP8863
From: Richard Purdie <rpurdie@rpsys.net>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Michael Hennerich <michael.hennerich@analog.com>
In-Reply-To: <1274857259-18771-1-git-send-email-vapier@gentoo.org>
References: <1274857259-18771-1-git-send-email-vapier@gentoo.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 May 2010 11:54:03 +0100
Message-ID: <1274871243.16229.73.camel@rex>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-26 at 03:00 -0400, Mike Frysinger wrote:
> From: Michael Hennerich <michael.hennerich@analog.com>
> 
> Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
>  drivers/video/backlight/Kconfig      |    6 ++--
>  drivers/video/backlight/adp8860_bl.c |   58 ++++++++++++++++++++++++----------
>  include/linux/i2c/adp8860.h          |   17 ++++++++++
>  3 files changed, 61 insertions(+), 20 deletions(-)

Added to the backlight tree, thanks.

Richard

