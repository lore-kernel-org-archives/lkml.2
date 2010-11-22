Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239Ab0KVOAp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 09:00:45 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36997 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754883Ab0KVOAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 09:00:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=WP4fF5adx4qLeiqDltD+wfOYi1odEBDl4IKQg8JzAza4Y5z5K0X+b74AwGrKI3oSzA
         jDOxpq3OUavP4V3/RO1fZQ4gZtJIYI0nawbx1OlEGQLyIG7GYvmLzyREm+9einHazrAW
         b8FqqlyP8Kml0TkGG0xOS7OEUogBGgqVud9uE=
Date: Mon, 22 Nov 2010 16:59:39 +0300
From: Dan Carpenter <error27@gmail.com>
To: mahatma@eu.by
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] viafb: I2C/DDC LCD detection for VIA framebuffer
Message-ID: <20101122135939.GA8882@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>, mahatma@eu.by,
	linux-kernel@vger.kernel.org
References: <4CEA62BB.9040403@bspu.unibel.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CEA62BB.9040403@bspu.unibel.by>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 02:31:55PM +0200, Dzianis Kahanovich wrote:
> +static void via_i2c_detect(void)
> +{
> +	const u8 *edid;
        ^^^^^

> +free_edid:
> +		kfree(edid);
                ^^^^^^^^^^^

That probably shouldn't be const.

> +		if (n > 1)
> +			break;
> +	}
> +}
> +
> 

regards,
dan carpenter
