Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979Ab2ICHur (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 03:50:47 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48496 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab2ICHuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 03:50:46 -0400
MIME-Version: 1.0
In-Reply-To: <20120828073858.GK27166@arwen.pp.htv.fi>
References: <503A8CAE.6050606@yahoo.es>
	<20120827070323.GC28721@samfundet.no>
	<503B342C.9060300@yahoo.es>
	<20120827111431.GA27868@samfundet.no>
	<503B8B26.3050205@yahoo.es>
	<CAKohpo=ALUNOnQdQjNd1Y2jtocxjixKCiBrRZp8qGErqg1LSKw@mail.gmail.com>
	<503C6B67.2010903@yahoo.es>
	<20120828073858.GK27166@arwen.pp.htv.fi>
Date: Mon, 3 Sep 2012 10:50:44 +0300
Message-ID: <CAHp75VeFDRYXuY0bkry-Leo-uGqEGYBm46wKfmj_Vxt_m3KO7A@mail.gmail.com>
Subject: Re: [PATCH 1/2] dw_dmac: make driver endianness configurable
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: balbi@ti.com
Cc: Hein Tibosch <hein_tibosch@yahoo.es>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        spear-devel <spear-devel@list.st.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "ludovic.desroches" <ludovic.desroches@atmel.com>,
        Havard Skinnemoen <havard@skinnemoen.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2012 at 10:39 AM, Felipe Balbi <balbi@ti.com> wrote:
> Can you not read this from any internal register ? Synopsys generally
> adds a set of read only registers which we can use to guess which
> features where enabled in the IP when configuring it with their IP
> configuration tool.
You right. I have a patch to support few options like that already.
However, I can't share
it yet by some legal reasons.

-- 
With Best Regards,
Andy Shevchenko
