Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423Ab1GIPFU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 11:05:20 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:39541 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205Ab1GIPFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 11:05:19 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 9 Jul 2011 17:05:06 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: linux1394-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] firewire: cdev: ABI documentation enhancements
Message-ID: <20110709170506.5e036f86@stein>
In-Reply-To: <20110709164737.53cf7801@stein>
References: <20110709164226.519a81fe@stein>
	<20110709164322.2deb2f36@stein>
	<20110709164737.53cf7801@stein>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 09 Stefan Richter wrote:
> @@ -672,7 +661,7 @@ struct fw_cdev_remove_descriptor {
>   * @handle:	Handle to context, written back by kernel
>   *
>   * Prior to sending or receiving isochronous I/O, a context must be created.
> - * The context records information about the transmit or receive configuration
> + * The context records information about the transmit or receive Configuration
>   * and typically maps to an underlying hardware resource.  A context is set up
>   * for either sending or receiving.  It is bound to a specific isochronous
>   * @channel.

Disregard this hunk.
-- 
Stefan Richter
-=====-==-== -=== -=--=
http://arcgraph.de/sr/
