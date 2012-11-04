Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591Ab2KDH4E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 02:56:04 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:43236 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab2KDHz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 02:55:59 -0500
Date: Sun, 4 Nov 2012 08:55:55 +0100
From: Lee Jones <lee.jones@linaro.org>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, shemminger@vyatta.com,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH 9/9] Avoid 'statement with no effect' compiler warnings
Message-ID: <20121104075555.GB24262@gmail.com>
References: <1351980150-24145-1-git-send-email-lee.jones@linaro.org>
 <1351980150-24145-10-git-send-email-lee.jones@linaro.org>
 <20121104.010043.1842614952525101679.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121104.010043.1842614952525101679.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 04 Nov 2012, David Miller wrote:

> From: Lee Jones <lee.jones@linaro.org>
> Date: Sat,  3 Nov 2012 23:02:30 +0100
> 
> > Instead of issuing (0) statements when !CONFIG_SYSFS which will cause
> > 'warning: ', we'll use inline statements instead. This will effectively
> > do the same thing, but suppress any unnecessary warnings.
> > 
> > Cc: Stephen Hemminger <shemminger@vyatta.com>
> > Cc: bridge@lists.linux-foundation.org
> > Cc: netdev@vger.kernel.org
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> Applied, but please use more informative subject lines.
> 
> You should prefix your subject line after [PATCH ...] with
> the name of the subsystem you are touching, a ": " then
> the headline description.
> 
> So here you would have used "bridge: " and that's what I added when I
> commited this patch.

Yes, of course I should have done, and usually do.

This was an oversight, sorry about that.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
