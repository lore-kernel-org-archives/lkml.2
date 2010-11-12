Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab0KLD6E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 22:58:04 -0500
Received: from www.sr71.net ([198.145.64.142]:46327 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754561Ab0KLD6C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 22:58:02 -0500
X-Greylist: delayed 566 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Nov 2010 22:58:02 EST
Subject: Re: [PATCH][BUG FIX] leds: Fix bug with reading NAS SS4200 dmi code
From: Dave Hansen <dave@sr71.net>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1289529278.12418.391.camel@gandalf.stny.rr.com>
References: <1289529278.12418.391.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Thu, 11 Nov 2010 19:48:34 -0800
Message-ID: <1289533714.2835.457.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-11 at 21:34 -0500, Steven Rostedt wrote:
> Cc: Dave Hansen <dave@sr71.net>
> Cc: Richard Purdie <rpurdie@linux.intel.com>
> Cc: Arjan van de Ven <arjan@linux.intel.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> diff --git a/drivers/leds/leds-ss4200.c b/drivers/leds/leds-ss4200.c
> index a688293..614ebeb 100644
> --- a/drivers/leds/leds-ss4200.c
> +++ b/drivers/leds/leds-ss4200.c
> @@ -102,6 +102,7 @@ static struct dmi_system_id __initdata
> nas_led_whitelist[] = {
>                         DMI_MATCH(DMI_PRODUCT_VERSION, "1.00.00")
>                 }
>         },
> +       {}
>  }; 

Urg.  I'm dumb.  Thanks, Steven.

Acked-by: Dave Hansen <dave@sr71.net>

