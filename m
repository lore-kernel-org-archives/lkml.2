Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab0KJCbJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 21:31:09 -0500
Received: from mail.perches.com ([173.55.12.10]:4898 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287Ab0KJCbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 21:31:06 -0500
Subject: Re: [PATCH 1/9] drivers/gpu/drm/drm_stub.c: Use printf extension
 %pV
From: Joe Perches <joe@perches.com>
To: Kristian =?ISO-8859-1?Q?H=F8gsberg?= <krh@bitplanet.net>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
In-Reply-To: <AANLkTi=Nu=rncb8+BzEGtphEj452xwVTPPM+EbCz0Fm1@mail.gmail.com>
References: <cover.1289348757.git.joe@perches.com>
	 <4da8e82f773833e126fc5d2d5563093b784144e5.1289348757.git.joe@perches.com>
	 <AANLkTi=Nu=rncb8+BzEGtphEj452xwVTPPM+EbCz0Fm1@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Nov 2010 18:31:03 -0800
Message-ID: <1289356263.28590.85.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-09 at 21:16 -0500, Kristian Høgsberg wrote:
> On Tue, Nov 9, 2010 at 7:35 PM, Joe Perches <joe@perches.com> wrote:
> > Using %pV reduces the number of printk calls and
> > eliminates any possible message interleaving from
> > other printk calls.

> Wouldn't it be easier and more convenient to just make the %pV format
> specifier just expect a format string and the va_arg list?  Like this
>   printk(KERN_DEBUG "%pV", format, &args);
> I mean, the %pV is kernel specific and we can just change how it works.

No it wouldn't.

gcc would now warn about a mismatch between format and arguments.



