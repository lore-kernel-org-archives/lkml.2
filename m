Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932514Ab1DZACl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 20:02:41 -0400
Received: from kroah.org ([198.145.64.141]:55764 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932233Ab1DZACj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 20:02:39 -0400
Date: Mon, 25 Apr 2011 16:57:08 -0700
From: Greg KH <greg@kroah.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] staging: rt2860sta and rt2870sta: Remove drivers
 replaced in net/wireless
Message-ID: <20110425235708.GA4534@kroah.com>
References: <4d9fd480.hAgzst+KKyLoglqZ%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d9fd480.hAgzst+KKyLoglqZ%Larry.Finger@lwfinger.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 08, 2011 at 10:37:36PM -0500, Larry Finger wrote:
> >From 32759907431a113b5f4e4de7b34efdb485b474d3 Mon Sep 17 00:00:00 2001
> From: Larry Finger <Larry.Finger@lwfinger.net>
> Date: Thu, 7 Apr 2011 17:01:19 -0500
> Subject: [PATCH] staging: rt2860sta and rt2870sta: Remove drivers replaced in net/wireless
> 
> The staging driver rt2860sta is replaced by mainline driver rt2800pci, and
> rt2870sta is replaced by rt2800usb. As a result, the staging drivers are
> deleted.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> Greg,
> 
> This patch can be pulled from
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/lwfinger/linux-staging.git
> 

Pulled and pushed out, thanks for doing this.

greg k-h
