Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847Ab1KGQzw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 11:55:52 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:51006 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763Ab1KGQzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 11:55:50 -0500
Message-ID: <4EB80D92.8050507@lwfinger.net>
Date: Mon, 07 Nov 2011 10:55:46 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Andrea Merello <andreamrl@tiscali.it>,
        Mike McCormack <mikem@ring3k.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        netdev@vger.kernel.org
Subject: Re: [PATCH] rtl8192e: Don't copy huge struct by value (and make it
 const).
References: <alpine.LNX.2.00.1111070017220.5763@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1111070017220.5763@swampdragon.chaosbits.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2011 05:21 PM, Jesper Juhl wrote:
> rtllib_is_shortslot() takes one argument - a struct that's more than a
> kilobyte large. It should take a pointer instead of copying such a
> huge struct - and the argument might as well be declared 'const' now
> that we are at it, since it is not modified. This patch makes these
> changes.
>
> Signed-off-by: Jesper Juhl<jj@chaosbits.net>

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
