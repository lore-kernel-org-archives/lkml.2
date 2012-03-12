Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab2CLRnN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 13:43:13 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:47273 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864Ab2CLRnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 13:43:09 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2] ARM: tegra: export tegra_gpio_{en,dis}able
To: Stephen Warren <swarren@wwwdotorg.org>, Alan Ott <alan@signal11.us>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>
In-Reply-To: <4F5A3965.5040300@wwwdotorg.org>
References: <1330630010-11241-2-git-send-email-alan@signal11.us> <1330727544-11617-1-git-send-email-alan@signal11.us> <4F5A3726.8030505@signal11.us> <4F5A3965.5040300@wwwdotorg.org>
Date: Mon, 12 Mar 2012 11:43:04 -0600
Message-Id: <20120312174304.8286D3E07B0@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Mar 2012 10:09:57 -0700, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 03/09/2012 10:00 AM, Alan Ott wrote:
> > On 03/02/2012 05:32 PM, Alan Ott wrote:
> >> From: Arnd Bergmann <arnd@arndb.de>
> >>
> >> These two functions are used in drivers that can be
> >> modules, so they need to be exported.
> >>
> >> Acked-by: Grant Likely <grant.likely@secretlab.ca>
> >> Acked-by: Olof Johansson <olof@lixom.net>
> ...
> > Did this patch ever get picked up into someone's tree?
> 
> It looks like Grant ack'd it which implies the thought Olof was going to
> take it through the Tegra tree perhaps? But Olof did the same, so is
> probably waiting for Grant to take it...

Applied, thx.

g.

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies,Ltd.
