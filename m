Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab2G3Osa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 10:48:30 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:60726 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754393Ab2G3Os2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 10:48:28 -0400
Date: Mon, 30 Jul 2012 10:48:27 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Julia Lawall <Julia.Lawall@lip6.fr>
cc: kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/9] drivers/usb/host/ehci-atmel.c: use devm_ functions
In-Reply-To: <1343591173-2819-2-git-send-email-Julia.Lawall@lip6.fr>
Message-ID: <Pine.LNX.4.44L0.1207301047260.1386-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Jul 2012, Julia Lawall wrote:

> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> The various devm_ functions allocate memory that is released when a driver
> detaches.  This patch uses these functions for data that is allocated in
> the probe function of a platform device and is only freed in the remove
> function.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
> Not compiled.

I have no objections to the patches in this series, but I haven't 
checked them in detail and I can't compile them either.

Alan Stern

