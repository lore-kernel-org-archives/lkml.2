Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751238Ab0KLGGp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 01:06:45 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:41013 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab0KLGGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 01:06:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IJm/39OaweYGru5dwmDApXinxH5l86D9u9lqbyCjrKzi8DNznBR/ZOQhZH5T+oJYNB
         QghyzbLPm/3N6J7lRVeHxiMC2UmULEFpQCXQG50BqqhpY2uRyZi5BBqorGcy9KQpVlrW
         i3oyW/u/g5P9yNaK0G5IORcIpCPjUblDbbkvM=
Date: Thu, 11 Nov 2010 22:06:36 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Marko Friedemann <mfr@bmx-chemnitz.de>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 1/3] Input: xpad - return proper error in error path
Message-ID: <20101112060636.GA5093@core.coreip.homeip.net>
References: <1289530116.20782.2.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289530116.20782.2.camel@mola>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 10:48:36AM +0800, Axel Lin wrote:
> In current implementation, xpad_probe return 0 when
> usb_alloc_urb failed for xpad->bulk_out and kzalloc failed for xpad->bdata.
> 
> This patch removes the initialization for error variable,
> assign the error code at the place the error happens instead.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied all 3, thanks Axel.

-- 
Dmitry
