Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab0LLQdv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 11:33:51 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58290 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955Ab0LLQds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 11:33:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=aeFg+tMTKNZkCibdZuhvcA1F4ngW07DAXhDqZEREtVFp+qcCnmJhLdHT3AfQkeUMKg
         NmbozS2Sz5o79OurZnk19FFtaOnSobQUvWKqnquQLVqWk/c2e/OYTmcSJHMBFpr2dKja
         +KtgfAIdvHhlXCguCvtJnFOjG9KpFgnqthsW4=
MIME-Version: 1.0
In-Reply-To: <1292159988-28268-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1292159988-28268-1-git-send-email-broonie@opensource.wolfsonmicro.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Sun, 12 Dec 2010 11:33:27 -0500
X-Google-Sender-Auth: 0jbFPxFd5FhwkBEdnYVlZeKPa9s
Message-ID: <AANLkTi=x3Y7-eOPXg42=sj44LAUXE0EnrbxmvRCyKQeo@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: Convert ADP5588 to new irq_ APIs
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 12, 2010 at 08:19, Mark Brown wrote:
> The genirq core is being updated to pass struct irq_data to irq_chip
> operations instead of an irq number. Update the ADP5588 GPIO driver to
> the new API.

"is being updated" ... does that mean it hasnt been merged yet and so
this patch depends on something else ?
-mike
