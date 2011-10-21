Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab1JUMT5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 08:19:57 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:38157 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053Ab1JUMT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 08:19:56 -0400
MIME-Version: 1.0
In-Reply-To: <1319192913.2702.38.camel@groo>
References: <1307713124-3946-1-git-send-email-carlos.chinea@nokia.com>
	<20111020125705.GA2121@earth.universe>
	<CACRpkdYBFGp4+oFUZvXn-wpUk0fmLiKixchQKcFo9XTDW=51+g@mail.gmail.com>
	<1319192913.2702.38.camel@groo>
Date: Fri, 21 Oct 2011 14:19:55 +0200
Message-ID: <CACRpkdb6sm-Xq=NSj2Qp8Lx0=hurEVtr91OLt0VtDLjEtn3_XA@mail.gmail.com>
Subject: Re: [RFC PATCHv5 0/7] HSI framework and drivers
From: Linus Walleij <linus.walleij@linaro.org>
To: Carlos Chinea <carlos.chinea@nokia.com>
Cc: Sebastian Reichel <sre@debian.org>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, govindraj.ti@gmail.com,
        pawel.szyszuk@stericsson.com, sjur.brandeland@stericsson.com,
        peter_henn@gmx.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 21, 2011 at 12:28 PM, Carlos Chinea <carlos.chinea@nokia.com> wrote:

(...)
> Basically, we have 2 alternatives for that:
>
> A. I create the branch with just the hsi_char and the hsi framework
> B. The same as A but with STE or another hsi/ssi controller driver.

I'd say (A) and then when someone (like me) fixes up the
STE HSI controller you can just git am that on top of the
framework. Possibly you can also stack the needed OMAP
changes in the same HSI tree provided you get an ACK
from the subsystem maintainer.

Yours,
Linus Walleij
