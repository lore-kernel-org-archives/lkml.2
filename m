Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756Ab2D3FHC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 01:07:02 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:55620 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755739Ab2D3FG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 01:06:58 -0400
Date: Sun, 29 Apr 2012 21:28:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: joseph daniel <josephdanielwalter@gmail.com>
Cc: Martyn Welch <martyn.welch@ge.com>, Gerard Snitselaar <dev@snitselaar.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/vme: Remove version.h include
Message-ID: <20120430012849.GB12956@kroah.com>
References: <1335694022-8819-1-git-send-email-josephdanielwalter@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335694022-8819-1-git-send-email-josephdanielwalter@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2012 at 04:07:02PM +0600, joseph daniel wrote:
> There are version.h includes that are not needed as make versioncheck reports.
> files:
> 1. drivers/staging/vme/devices/vme_pio2_core.c
> 2. drivers/staging/vme/devices/vme_pio2_gpio.c
> 
> Signed-off-by: joseph daniel <josephdanielwalter@gmail.com>

This is already in linux-next as well, sorry.

greg k-h
