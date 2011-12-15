Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932611Ab1LOTpI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 14:45:08 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60125 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366Ab1LOTpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 14:45:06 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kyungmin Park <kmpark@infradead.org>
Subject: Re: [PATCH] devfreq: Add devfreq maintainer entry
Date: Thu, 15 Dec 2011 20:48:06 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Kevin Hilman <khilman@ti.com>, MyungJoo Ham <myungjoo.ham@samsung.com>,
        myungjoo.ham@gmail.com
References: <20111215051013.GA23030@july>
In-Reply-To: <20111215051013.GA23030@july>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112152048.06595.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 15, 2011, Kyungmin Park wrote:
> From: Kyungmin Park <kyungmin.park@samsung.com>
> 
> As devfreq is merged at mainline. Also update the maintainer entry.
> 
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

So long as you will send pull requests to me:

Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

> ---
> diff --git a/MAINTAINERS b/MAINTAINERS
> index b9db108..a5d2840 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2192,6 +2192,13 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git
>  S:	Maintained
>  F:	drivers/usb/dwc3/
>  
> +DEVICE FREQUENCY (DEVFREQ)
> +M:	MyungJoo Ham <myungjoo.ham@samsung.com>
> +M:	Kyungmin Park <kyungmin.park@samsung.com>
> +L:	linux-kernel@vger.kernel.org
> +S:	Maintained
> +F:	drivers/devfreq/
> +
>  DEVICE NUMBER REGISTRY
>  M:	Torben Mathiasen <device@lanana.org>
>  W:	http://lanana.org/docs/device-list/index.html
> 
> 

