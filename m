Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab0JMMba (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 08:31:30 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:50328 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999Ab0JMMb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 08:31:29 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 13 Oct 2010 14:31:10 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] firewire: nosy: char device is not seekable
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <tkrat.42de7ec9907e63aa@s5r6.in-berlin.de>
Message-ID: <tkrat.74a48d50ea6be5f5@s5r6.in-berlin.de>
References: <tkrat.42de7ec9907e63aa@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
>  static const struct file_operations nosy_ops = {
>  	.owner =		THIS_MODULE,
> +	.llseek =		no_llseek,
>  	.read =			nosy_read,
>  	.unlocked_ioctl =	nosy_ioctl,
>  	.poll =			nosy_poll,

PS; this is safe since the only client that uses this interface is
nosy-dump in linux/tools/firewire and it knows not to seek in this char
dev.
-- 
Stefan Richter
-=====-==-=- =-=- -==-=
http://arcgraph.de/sr/

