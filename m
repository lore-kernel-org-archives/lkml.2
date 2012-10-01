Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab2JAPZH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 11:25:07 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:32980 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751955Ab2JAPZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 11:25:04 -0400
X-Sasl-enc: KuVAolQDHG3iVS7FOGZv6tA+c6E/5Eh8JkZZuLfcEdhc 1349105102
Date: Mon, 1 Oct 2012 08:25:01 -0700
From: Greg KH <greg@kroah.com>
To: Christian Gmeiner <christian.gmeiner@gmail.com>
Cc: akpm@linux-foundation.org, stable@vger.kernel.org, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] leds-ot200: Fix error caused by shifted mask
Message-ID: <20121001152501.GA7978@kroah.com>
References: <1349095840-26450-1-git-send-email-christian.gmeiner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349095840-26450-1-git-send-email-christian.gmeiner@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 02:50:40PM +0200, Christian Gmeiner wrote:
> During the development of this driver an in-house register
> documentation was used. The last weeks some integration tests
> were done and this problem was found. It turned out that
> the released register documentation is wrong.
> 
> The fix is very simple: shift all mask by one.
> 
> Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>
> ---
>  drivers/leds/leds-ot200.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
