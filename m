Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758656Ab2INIQC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 04:16:02 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:58324 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755866Ab2INIO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 04:14:56 -0400
Date: Fri, 14 Sep 2012 09:14:51 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 18/19] gpio: Provide the tc3589x GPIO expander driver
 with an IRQ domain
Message-ID: <20120914081449.GC3374@gmail.com>
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
 <1347016499-29354-19-git-send-email-lee.jones@linaro.org>
 <CACRpkdYbWEq5mhTcewmxEpcivXkVyQS_56QRU67G40zcRXnUCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdYbWEq5mhTcewmxEpcivXkVyQS_56QRU67G40zcRXnUCA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 06:10:59AM -0700, Linus Walleij wrote:
> On Fri, Sep 7, 2012 at 1:14 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > In preparation for Device Tree enablement all IRQ controllers
> > should control their own IRQ domain. This patch provides just
> > that for the tc3589x GPIO expander.
> >
> > CC: Grant Likely <grant.likely@secretlab.ca>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> Looks very good again,
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> I presume you will want to push the whole shebang through
> ARM SoC, but if that doesn't work out I am very tempted to
> apply this patch to the GPIO tree immediately so it lands
> in v3.7.

I'd like to push my patch-set for v3.7 too.

I just need to collect all my Acks before I can send a pull-request.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
