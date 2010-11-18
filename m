Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758174Ab0KROFb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 09:05:31 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:51978 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758141Ab0KROF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 09:05:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RtNRQcGWSw9MnWgT/ziPovseJK3htuz9Z0Fpz3fq841tCo9WIFDLWsMLgmsO3Sz8nL
         r0DWrfP6av2WAB/kjfv9dXSL6YZ7KX7oAQlP2UQnCly3J/WmFTMDvAZzPp/bNlZgVwoZ
         kUbn+eZl2M3VnraG1p4T0GBZlDoCRAawJ/aSA=
Date: Thu, 18 Nov 2010 17:05:22 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: rklein@nvidia.com, broonie@opensource.wolfsonmicro.com, achew@nvidia.com,
        olof@lixom.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] POWER: Add gpio charger driver
Message-ID: <20101118140522.GD19527@oksana.dev.rtsoft.ru>
References: <1287663957-30099-1-git-send-email-lars@metafoo.de>
 <1287676501-23254-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1287676501-23254-1-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 05:55:01PM +0200, Lars-Peter Clausen wrote:
> This patch adds a simple driver for chargers indicating their online status
> through a GPIO pin.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> 
> ---
> Changes since v1
> * Fix typo in Kconfig
> * Fix whitespace issues
> * Add missing includes in the header file
> * Make the irq field of the driver struct unsigned and assume that 0 is not a
>   valid irq.

Applied, thanks!

But please, look at Mark Brown comments. If they are still
applicable, the follow up patch would be great.

Thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
