Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322Ab2KFI70 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 03:59:26 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51209 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab2KFI7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 03:59:25 -0500
Date: Tue, 6 Nov 2012 09:59:31 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Omar Ramirez Luna <omar.luna@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Loic PALLARDY <loic.pallardy@st.com>, Arnd Bergmann <arnd@arndb.de>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dom Cobley <popcornmix@gmail.com>, Wim Van Sebroeck <wim@iguana.be>,
        Suman Anna <s-anna@ti.com>, Juan Gutierrez <jgutierrez@ti.com>,
        Felipe Contreras <felipe.contreras@nokia.com>,
        Tejun Heo <tj@kernel.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mailbox: OMAP: introduce mailbox framework
Message-ID: <20121106085931.GA26335@kroah.com>
References: <1352170552-29564-1-git-send-email-omar.luna@linaro.org>
 <1352170552-29564-2-git-send-email-omar.luna@linaro.org>
 <509886A2.5060509@wwwdotorg.org>
 <CACRpkdb0nCaV5L5xCnzje3w=t7+TZpcvCCUDRPi-10t+oF8UGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdb0nCaV5L5xCnzje3w=t7+TZpcvCCUDRPi-10t+oF8UGg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2012 at 09:55:52AM +0100, Linus Walleij wrote:
> On Tue, Nov 6, 2012 at 4:40 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> 
> > Is this a public interface to the driver? If so, shouldn't the header be
> > in include/linux somewhere?
> 
> I think the split out of the public header is done in patch 2/2.

Yes, but the names are still omap_*, which doesn't make much sense here.

greg k-h
