Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab2EHMdm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 08:33:42 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43695 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810Ab2EHMdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 08:33:39 -0400
MIME-Version: 1.0
In-Reply-To: <20120504204455.GR14230@opensource.wolfsonmicro.com>
References: <20120504185850.GO14230@opensource.wolfsonmicro.com>
	<4FA432E9.9050606@wwwdotorg.org>
	<20120504204455.GR14230@opensource.wolfsonmicro.com>
Date: Tue, 8 May 2012 14:33:38 +0200
Message-ID: <CACRpkdbyp=BNGn8Eub6vcAgB9CS5PhYcGt2foi8kNxA3oU5Fzg@mail.gmail.com>
Subject: Re: Handling of modular boards
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Alessandro Rubini <rubini@gnudd.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-embedded@vger.kernel.org,
        linux-kernel@vger.kernel.org, Igor Grinberg <grinberg@compulab.co.il>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@ardb.de>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 4, 2012 at 10:44 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Fri, May 04, 2012 at 01:50:01PM -0600, Stephen Warren wrote:
>
>> b) Doesn't integrate well with hotplug; the DT for the board
>> configuration is static at boot. What if a board can be unplugged and
>> another plugged in; a reboot or similar would be needed to adjust the
>> kernel to this.
>
> This is another issue - a similar set of problems does apply to some PCI
> type cards where the PCI device is essentially a bridge to a typical
> embedded system - though practically speaking it's much less severe.

I think Alessandro is working on a board like that right now, so looping
in Ale to this discussion to get his attention...

Linus Walleij
