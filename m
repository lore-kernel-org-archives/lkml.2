Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851Ab1FIUV2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 16:21:28 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:39695 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755660Ab1FIUV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 16:21:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Zgu8maL2Ei8aU7ImBGbd7RzHtp8cyHQnbQg5oNEPS/WEwl38u9ucY1Jp6oizEq+r6Z
         StDzJJukWoHmWLyj6LKEuhYx1BruY7zJ8DSz9+tB9Kn/vYKryDs7Sd+X/9B0jcvlcs6y
         ppgBBIL/7aaN3GwxdmVfMxxZtZ/7A+IDWSbPI=
Date: Thu, 9 Jun 2011 23:19:00 +0300
From: Mika Westerberg <mika.westerberg@iki.fi>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, kernel@wantstofly.org,
        akpm@linux-foundation.org, joe@perches.com, davem@davemloft.net
Subject: Re: [PATCH] ep93xx_eth: Update MAINTAINERS
Message-ID: <20110609201900.GC2857@acer>
References: <201106091313.25840.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106091313.25840.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 09, 2011 at 01:13:25PM -0700, H Hartley Sweeten wrote:
> Lennert stated that he has been short on time lately. Since I'm maintaining
> the ep93xx core stuff, I'm willing to also take over maintaining the Ethernet
> driver.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Lennert Buytenhek <kernel@wantstofly.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Joe Perches <joe@perches.com>
> Cc: "David S. Miller" <davem@davemloft.net>

Acked-by: Mika Westerberg <mika.westerberg@iki.fi>

Thank you for doing this!
