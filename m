Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965556Ab2EOChG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:37:06 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:35913 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965382Ab2EOChC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:37:02 -0400
MIME-Version: 1.0
In-Reply-To: <1337014097-5034-2-git-send-email-b.spranger@linutronix.de>
References: <1337014097-5034-1-git-send-email-b.spranger@linutronix.de>
	<1337014097-5034-2-git-send-email-b.spranger@linutronix.de>
Date: Tue, 15 May 2012 11:37:01 +0900
Message-ID: <CANqRtoRLbbkr7YnvOrixJ=RhVPDTQCqzo_tgu9qUEFDeHR9cRQ@mail.gmail.com>
Subject: Re: [PATCH] uio_pdrv_genirq: get irq through platform resource if not
 set otherwise
From: Magnus Damm <magnus.damm@gmail.com>
To: Benedikt Spranger <b.spranger@linutronix.de>
Cc: hjk@hansjkoch.de, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 1:48 AM, Benedikt Spranger
<b.spranger@linutronix.de> wrote:
> Platform devices are configured through platform resources. The interrupt
> in the driver uio_pdrv_genirq is instead configured through a side channel
> i.e. the platform data structure. Make it possible to use the generic
> configuration scheme via platform resource.
>
> Signed-off-by: Benedikt Spranger <b.spranger@linutronix.de>
> ---
>  drivers/uio/uio_pdrv_genirq.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)

Looks fine to me, thank you!

Acked-by: Magnus Damm <damm@opensource.se>
