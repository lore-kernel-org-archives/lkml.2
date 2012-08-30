Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866Ab2H3Mbz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 08:31:55 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57253 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab2H3Mbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 08:31:53 -0400
Date: Thu, 30 Aug 2012 13:31:48 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH 18/22] ARM: ux500: Rename MSP board file to something
 more meaningful
Message-ID: <20120830123146.GF14145@gmail.com>
References: <1344527268-5964-1-git-send-email-lee.jones@linaro.org>
 <1344527268-5964-19-git-send-email-lee.jones@linaro.org>
 <CACRpkdaJcfLNzZ4s4NOyBLROjNbNfP8m0EewFkwe6tTrCS-Hog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdaJcfLNzZ4s4NOyBLROjNbNfP8m0EewFkwe6tTrCS-Hog@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 01:20:32PM +0200, Linus Walleij wrote:
> On Thu, Aug 9, 2012 at 5:47 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > The 'msp' board file does more than just register MSP devices. It
> > also registers some other components necessary to get audio working
> > on ux500 based platforms; such as the PCM and Machine Drivers. For
> > that reason we're changing the filename to be more encompassing -
> > 'audio'.
> >
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> Ideally I want Ola to confirm this but it looks OK to me.
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

Poke for Ola.

I'm guessing it's okay, as Ola told me to rename the file 'msp' -> 'audio'.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
