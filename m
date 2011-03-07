Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546Ab1CGP5a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 10:57:30 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58114 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755054Ab1CGPzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 10:55:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=s4I18QIj1yCrg80QVOeyHhfDXGnlKhdUzSROS6xq3gxl28I0thWNvRxD+lDIqqfyXw
         OKJpV421BJKMQtKgTgj9eK27NBwOLNw2qfsXVuL7WmqxP6XuBTjt2xyX07L2PMPiPibh
         gbayefBbpCQWMfw46EE8z7+GpajtPaGqNhAv0=
Date: Mon, 7 Mar 2011 18:55:29 +0300
From: Dan Carpenter <error27@gmail.com>
To: Marek Belisko <marek.belisko@open-nandra.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/21] staging: ft1000: Fix coding style in
 ft1000_usb_transmit_complete function.
Message-ID: <20110307155529.GV3416@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Marek Belisko <marek.belisko@open-nandra.com>, gregkh@suse.de,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1299486086-7325-1-git-send-email-marek.belisko@open-nandra.com>
 <1299486086-7325-12-git-send-email-marek.belisko@open-nandra.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299486086-7325-12-git-send-email-marek.belisko@open-nandra.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 07, 2011 at 09:21:16AM +0100, Marek Belisko wrote:
> -    if (urb->status)
> -        printk("%s: TX status %d\n", ft1000dev->net->name, urb->status);
> +	if (urb->status)
> +		DEBUG("%s: TX status %d\n", ft1000dev->net->name, urb->status);
>  

Why did you change the printk() to a DEBUG()?  That's a behavior change,
and it should have been mentioned in the commit message.

regards,
dan carpenter

> -    netif_wake_queue(ft1000dev->net);
> +	netif_wake_queue(ft1000dev->net);
>  
>      //DEBUG("Return from ft1000_usb_transmit_complete\n");
>  }

