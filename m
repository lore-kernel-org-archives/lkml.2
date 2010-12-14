Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760027Ab0LNUzN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 15:55:13 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59986 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759636Ab0LNUzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 15:55:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=xLUYYaXowcrrAv/NcgugG5zAcsZ6YhQlIftIBWZngcrYaIeobu2Y6YG3DFfi2ZBIRK
         M06NTIP0clMqn3lB+hWy9PNMByPayL6Dsl6ZqQ53syzaaBhynkq9746vN4ZqAGNDWUwB
         bi+pnMoAlbF4LvzXNE6dqjZ8EJp9Pn8GMfa5U=
MIME-Version: 1.0
In-Reply-To: <20101214124332.07f2a212.akpm@linux-foundation.org>
References: <1292159988-28268-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20101214124332.07f2a212.akpm@linux-foundation.org>
From: Mike Frysinger <vapier@gentoo.org>
Date: Tue, 14 Dec 2010 15:54:50 -0500
X-Google-Sender-Auth: Sxdtb-MRVtfaAxm9FvCM5m4g_4g
Message-ID: <AANLkTimhRbC6jvBFgpsffmepNd2AkaNW6yRwj2OmBGSG@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: Convert ADP5588 to new irq_ APIs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>,
        Lennert Buytenhek <buytenh@wantstofly.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 15:43, Andrew Morton wrote:
> On Sun, 12 Dec 2010 13:19:48 +0000 Mark Brown wrote:
>> The genirq core is being updated to pass struct irq_data to irq_chip
>> operations instead of an irq number. Update the ADP5588 GPIO driver to
>> the new API.
>
> Seems to be the same as Lennert's patch, except he called it "d"?

other way around ... Lennert's patch is like Mark's
-mike
