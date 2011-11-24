Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773Ab1KXIn0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 03:43:26 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38934 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995Ab1KXInY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 03:43:24 -0500
MIME-Version: 1.0
X-Originating-IP: [93.173.47.67]
In-Reply-To: <4ECD5767.90307@codeaurora.org>
References: <1319536106-25802-1-git-send-email-ohad@wizery.com>
 <4ECC67B9.4050306@codeaurora.org> <CAK=WgbYyrbZLmDOx8yKWwjhn2MYN8669FDRvsYZSyLj1equcTw@mail.gmail.com>
 <20111123161012.GA31423@sirena.org.uk> <4ECD5767.90307@codeaurora.org>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 24 Nov 2011 10:43:03 +0200
Message-ID: <CAK=Wgba49eu_MGTWP_SND1=KDPp=MfuDyvxFGA_NND=ydqBmZA@mail.gmail.com>
Subject: Re: [PATCH 0/7] Introducing a generic AMP framework
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Tony Lindgren <tony@atomide.com>, Brian Swetland <swetland@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>, akpm@linux-foundation.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 10:28 PM, Saravana Kannan
<skannan@codeaurora.org> wrote:
> remoteproc would probably be the best fit since it's already used in the
> code and people are used to discussing about it.

Guys you realize that 'amp' isn't really being used in the code
itself; this discussion boils down to the text we have in the patches'
subject line and the top level Kconfig/folder entry :)

But, sure, I'll just drop those 'amp' text instances, and we'll have
'remoteproc' and 'rpmsg' as separate top-level frameworks again.

Thanks,
Ohad.
