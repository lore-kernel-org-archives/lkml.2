Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135Ab0HVR0n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 13:26:43 -0400
Received: from cantor.suse.de ([195.135.220.2]:37754 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708Ab0HVR0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 13:26:42 -0400
Date: Sun, 22 Aug 2010 10:10:03 -0700
From: Greg KH <gregkh@suse.de>
To: Pekka Enberg <penberg@kernel.org>
Cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] firmware: fix request_firmware() error handling
Message-ID: <20100822171003.GA8658@suse.de>
References: <1282489770-2757-1-git-send-email-penberg@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282489770-2757-1-git-send-email-penberg@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 22, 2010 at 06:09:30PM +0300, Pekka Enberg wrote:
> If _request_firmware() fails and we do release_firmware(), update the pointer
> pointed to by 'firmware_p' so that we don't return a free'd pointer to the
> caller.
> 
> This patch fixes a boot-time crash on my MacBook that's caused by failing
> isight_firmware_load(). The bug was introduced in commit f8a4bd34 ("firmware
> loader: embed device into firmware_priv structure") and makes 2.6.36-rc1
> unusable on my box.
> 
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Signed-off-by: Pekka Enberg <penberg@kernel.org>

Thanks, already in my tree and linux-next and will be going to Linus on
Monday.

greg k-h
