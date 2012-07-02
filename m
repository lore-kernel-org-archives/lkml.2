Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932841Ab2GBJJc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 05:09:32 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:39685 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932716Ab2GBJJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 05:09:27 -0400
MIME-Version: 1.0
In-Reply-To: <4FE86727.5010400@linaro.org>
References: <4FDEE98D.7010802@linaro.org>
	<4FDF2D58.9010006@ti.com>
	<4FE86727.5010400@linaro.org>
Date: Mon, 2 Jul 2012 11:09:26 +0200
Message-ID: <CACRpkdYaLweX-4YkWotuFFWoqEjOLKoNCsurCxxWNfq7QznPnw@mail.gmail.com>
Subject: Re: linux-next : cpuidle - could you add my tree please
From: Linus Walleij <linus.walleij@linaro.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-acpi@vger.kernel.org,
        linux-pm@lists.linux-foundation.org,
        Lists Linaro-dev <linaro-dev@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@ti.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Amit Kucheria <amit.kucheria@linaro.org>, linux-next@vger.kernel.org,
        Colin Cross <ccross@android.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rob Lee <rob.lee@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2012 at 3:27 PM, Daniel Lezcano
<daniel.lezcano@linaro.org> wrote:

> we discussed last week to put in place a tree grouping the cpuidle
> modifications [1]. Is it possible to add the tree ?
>
> git://git.linaro.org/people/dlezcano/cpuidle-next.git #cpuidle-next

Thanks for doing this.

Since MAINTAINERS is lacking a listed maintainer for cpuidle,
are you also going to add yourself as maintainer and list this
tree in that file, or is this a one-time exercise?

Yours,
Linus Walleij
