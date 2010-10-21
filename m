Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758520Ab0JUPGA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 11:06:00 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:51613 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab0JUPF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 11:05:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tOl10Tcn7s939uPby2R9J8FI4/4RH72VHxuGRG+kvKWfMrfeloFMrMiybqX5/9pdSk
         7auoehMwbdh93vumX4z3r2tgbpp0t5tc9zbEpTIIgwKxAyov3aSrOKHLXCG/Bq0oFd5K
         VrIeu8t/aakrKPWUcBHHDbR1fjx0Mp0rLBHvM=
Date: Thu, 21 Oct 2010 19:05:54 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: rklein@nvidia.com, broonie@opensource.wolfsonmicro.com, achew@nvidia.com,
        olof@lixom.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] POWER: Add gpio chager driver
Message-ID: <20101021150554.GA409@oksana.dev.rtsoft.ru>
References: <4CC02FF9.3050804@metafoo.de>
 <1287663957-30099-1-git-send-email-lars@metafoo.de>
 <20101021141407.GA26602@oksana.dev.rtsoft.ru>
 <4CC053B5.3090904@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4CC053B5.3090904@metafoo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 04:52:37PM +0200, Lars-Peter Clausen wrote:
[...]
> >> +	gpio_charger->irq = gpio_to_irq(pdata->gpio);
> >> +	if (gpio_charger->irq >= 0) {
> > 
> > 0 isn't valid IRQ number. The check should be just 'if (gpio_charger->irq)'.
> 
> While it is unlikely to be used for an gpio IRQ, as far as I know 0 is a valid IRQ
> number.

0 may be a valid HW IRQ, but not VIRQ.

http://www.mail-archive.com/linuxppc-dev@lists.ozlabs.org/msg22857.html

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
