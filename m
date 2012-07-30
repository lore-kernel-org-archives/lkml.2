Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120Ab2G3QyR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 12:54:17 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:42522 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263Ab2G3QyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 12:54:15 -0400
Message-ID: <5016BC34.8070306@wwwdotorg.org>
Date: Mon, 30 Jul 2012 10:54:12 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: Alan Stern <stern@rowland.harvard.edu>, kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] drivers/usb/host/ehci-tegra.c: use devm_ functions
References: <1343659425-24563-3-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1343659425-24563-3-git-send-email-Julia.Lawall@lip6.fr>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2012 08:43 AM, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> The various devm_ functions allocate memory that is released when a driver
> detaches.  This patch uses these functions for data that is allocated in
> the probe function of a platform device and is only freed in the remove
> function.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Tested-by: Stephen Warren <swarren@wwwdotorg.org>
