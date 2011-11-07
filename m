Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab1KGKMY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 05:12:24 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36716 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421Ab1KGKMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 05:12:22 -0500
MIME-Version: 1.0
In-Reply-To: <20111107012643.GG30282@windriver.com>
References: <1320580651-4860-1-git-send-email-jonas.gorski@gmail.com> <20111107012643.GG30282@windriver.com>
From: Jonas Gorski <jonas.gorski@gmail.com>
Date: Mon, 7 Nov 2011 11:12:00 +0100
Message-ID: <CAOiHx=mmLrfqtp3Nm4WgUT9Vu8pYnVht7tBvwguGMN91bj0Dig@mail.gmail.com>
Subject: Re: [PATCH] MTD: MAPS: bcm963xx-flash.c: explicitly include module.h
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org, Florian Fainelli <florian@openwrt.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI Paul,

On 7 November 2011 02:26, Paul Gortmaker <paul.gortmaker@windriver.com> wrote:
>On 06/11/2011 (Sun 12:57) Jonas Gorski wrote:
>> This patch is based on next-20111104 and probably should go through Paul's module.h cleanup tree.
>
> I can put it in the module.h tree, but for files that are using module.h
> stuff, they can simply add it via the normal maintainer flow, since
> files that use modular stuff should include module.h regardless and
> there are no dependencies on the module.h content for things like this.

I'm fine with either (though going through the MTD-tree will probably
warrant a resubmission with a shortened changelog as it doesn't break
there (yet)).

@David, any preference there? Should I resubmit?

Regards
Jonas
