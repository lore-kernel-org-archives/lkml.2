Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760005Ab0EDSDG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 14:03:06 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48838 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757607Ab0EDSDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 14:03:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rO0bR/71mqHibG6019pDAhN8E4fvDQ9/7AjCq9XNVVPKxtzOSQmTgT6MQ6piwZDYdc
         3YAFWTp4+9ugz/sw3Nfarj2SsReUVshkNsyKIXY+nTZLQFntI6pBi+Upe3nV7J6fjuw8
         eFqfjWXHdGpdYNdUh/GARL0U5yoO8kd9V7Wxs=
Date: Tue, 4 May 2010 11:02:47 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Bastien Nocera <hadess@hadess.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Disable i8042 checks on Intel Apple Macs
Message-ID: <20100504180247.GC29428@core.coreip.homeip.net>
References: <1272994594.13354.215.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272994594.13354.215.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 04, 2010 at 06:36:34PM +0100, Bastien Nocera wrote:
> As those computers never had any i8042 controllers, and the
> current lookup code could potentially lock up/hang/wait for
> timeout for long periods of time.
> 
> Fixes intermittent hangs on boot on a MacbookAir1,1
> 
> Signed-off-by: Bastien Nocera <hadess@hadess.net>
> ---
>  drivers/input/serio/i8042.c |   18 ++++++++++++++++++
>  1 files changed, 18 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
> index d84a36e..2be7207 100644
> --- a/drivers/input/serio/i8042.c
> +++ b/drivers/input/serio/i8042.c

This should go into i8042-x86ia64io.h and used to create PNP whitelist.

Thanks.

-- 
Dmitry
