Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123Ab0FNQVL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 12:21:11 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:64920 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755855Ab0FNQVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 12:21:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EF0KzzedG/ELvdUj41qhEfiUcAvKDrOsTXH7PGYGCNJLp18Wt069KKz2hRmKg0Jgl0
         Eah46Q0IaLFTQpm8E62QyrpPqe/+OVKh7YSWu0A2cEgADZRX7yKlyETo6k/9U3Lp8jW5
         Lk3oLWPKYF582MhrJpyLLSYOfM16Vi2Qnyel8=
Date: Mon, 14 Jun 2010 19:51:08 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 23/26] power: Add JZ4740 battery driver.
Message-ID: <20100614155108.GA30552@oksana.dev.rtsoft.ru>
References: <1275505397-16758-1-git-send-email-lars@metafoo.de>
 <1275505950-17334-7-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1275505950-17334-7-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 09:12:29PM +0200, Lars-Peter Clausen wrote:
> This patch adds support for the battery voltage measurement part of the JZ4740
> ADC unit.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> Cc: Anton Vorontsov <cbouatmailru@gmail.com>
> ---

Looks good. I see this is an RFC. Do you want me to apply it
or there's a newer version to be submitted?

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
