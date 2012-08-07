Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab2HGSZw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 14:25:52 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41418 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab2HGSZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 14:25:51 -0400
Date: Tue, 7 Aug 2012 19:25:42 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Borislav Petkov <bp@alien8.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Steven Rostedt <rostedt@goodmis.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: awful kconfig help texts.
Message-ID: <20120807182542.GC14711@sirena.org.uk>
References: <20120731151600.GA19412@redhat.com>
 <20120731170741.GA4735@x1.osrc.amd.com>
 <20120731172638.GE16873@home.goodmis.org>
 <20120731174249.GB4735@x1.osrc.amd.com>
 <20120801074742.GH29673@avionic-0098.adnet.avionic-design.de>
 <20120801085644.GA21303@liondog.tnic>
 <5018F537.209@metafoo.de>
 <20120801092625.GB21303@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120801092625.GB21303@liondog.tnic>
X-Cookie: Now, let's SEND OUT for QUICHE!!
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2012 at 11:26:25AM +0200, Borislav Petkov wrote:

> but when I enable the CONFIG_PWM option on x86, I don't see any drivers
> there. So the logical thing to do would be to hide that option on arches
> which don't have such chips.

That's because the subsystem was only just added.  As soon as we get
support for platform independant devices the situation will change
(though you may need to turn on some MFD cores).  This is an issue in
general, Kconfig could perhaps be smarter about checking if the submenu
is empty.
