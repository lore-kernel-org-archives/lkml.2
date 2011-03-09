Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790Ab1CILnm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 06:43:42 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:36778 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031Ab1CILnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 06:43:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=HUo07ia9E6F0xWWEQ+5LHA3SRrTptF9trGrU2Uy+QV5/jnT28hWKebIaAzfgCjzNd5
         lYJtlCsMokw83EJ+p6BlCAijdyhCkwwJh7UQ+WSbMxPwvObgnFawSqsT6sGZ28M6jZNH
         RGIfkIe/9AMQMjqpTG5nEDutUe5d3qagcY/C0=
MIME-Version: 1.0
In-Reply-To: <1299321935-6727-1-git-send-email-linus.walleij@stericsson.com>
References: <1299321935-6727-1-git-send-email-linus.walleij@stericsson.com>
Date: Wed, 9 Mar 2011 12:43:41 +0100
X-Google-Sender-Auth: rvs5FWND1fQHSZnbbTNpVVV7xMI
Message-ID: <AANLkTik2HKbqWvCXchUVMqtPrTSgf7tXmFtaaXDGVM+J@mail.gmail.com>
Subject: Re: [PATCH 0/5] ab8500 gpadc fixes
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        Daniel Willerud <daniel.willerud@stericsson.com>,
        Mattias Wallin <mattias.wallin@stericsson.com>,
        Karl Komierowski <karl.komierowski@stericsson.com>,
        Johan Palsson <johan.palsson@stericsson.com>,
        Arun Murthy <arun.murthy@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/3/5 Linus Walleij <linus.walleij@stericsson.com>:

> I had to do this now beacue the current driver that is in the
> tree makes my platform crash ([2/5] fixes that problem) like
> this:

Sam, are these patches OK? I'd very much like to have
booting code in next that's why...

Yours,
Linus Walleij
