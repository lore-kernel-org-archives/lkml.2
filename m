Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554Ab1AEHJh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 02:09:37 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46091 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab1AEHJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 02:09:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=p4tMO4Vs6CA6V0GGEk3qNAi2NriWraXdOj9gxBiv/NF+JwVbKxPERiG5q1CGgieBAA
         fwIEWjuNWxFg6kXhhWYtjHeqzJISbXcDCvqRpia02t4b/8YatonLHZYVGbunt5T9co/s
         a3FgfIY+UBYuXs5y192IJvcq+XajOskMQz73Q=
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] leds/h1940: Use gpiolib for latch access / fix build failure
Date: Wed, 5 Jan 2011 09:08:13 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-gentoo-r3-anarsoul; KDE/4.5.4; i686; ; )
Cc: Peter Huewe <peterhuewe@gmx.de>, Ben Dooks <ben-linux@fluff.org>,
        Vincent Sanders <support@simtec.co.uk>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Purdie <rpurdie@rpsys.net>
References: <1291932292-16049-1-git-send-email-peterhuewe@gmx.de> <201012100016.58130.anarsoul@gmail.com> <20110104153725.2f3fede2.akpm@linux-foundation.org>
In-Reply-To: <20110104153725.2f3fede2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101050908.14661.anarsoul@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 January 2011 01:37:25 Andrew Morton wrote:
> On Fri, 10 Dec 2010 00:16:57 +0200
> 
> Vasily Khoruzhick <anarsoul@gmail.com> wrote:
> > On Friday 10 December 2010 00:04:52 Peter Huewe wrote:
> > > This patch fixes a build failure by converting leds-h1940.c to use
> > > gpiolib for latch access introduced by 14477095abc6
> > > (ARM: h1940: Use gpiolib for latch access)
> > > 
> > > Unfortunately this driver was not converted back then.
> > 
> > I sent similar patch (however, my patch does gpio_request/gpio_free)
> > ~month ago.
> > 
> > Here's link:
> > http://www.spinics.net/lists/arm-kernel/msg103429.html
> 
> So which patch to use?
> 
> I queued Peter's patch because it's simpler.  I queued it for
> 2.6.38-rc1, taged for backporting into 2.6.37.x, so we have a bit of
> time to think about it.

It's simplier, but it does not request gpio before use. It will work, but will 
print nasty warning.

Regards,
Vasily
