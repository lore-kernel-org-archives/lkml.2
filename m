Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264Ab2HAKE7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 06:04:59 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57436 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752643Ab2HAKE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 06:04:58 -0400
Date: Wed, 1 Aug 2012 12:04:55 +0200
From: Borislav Petkov <bp@alien8.de>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Steven Rostedt <rostedt@goodmis.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: awful kconfig help texts.
Message-ID: <20120801100455.GD21303@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Thierry Reding <thierry.reding@avionic-design.de>,
	Steven Rostedt <rostedt@goodmis.org>, Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20120731151600.GA19412@redhat.com>
 <20120731170741.GA4735@x1.osrc.amd.com>
 <20120731172638.GE16873@home.goodmis.org>
 <20120731174249.GB4735@x1.osrc.amd.com>
 <20120801074742.GH29673@avionic-0098.adnet.avionic-design.de>
 <20120801085644.GA21303@liondog.tnic>
 <5018F537.209@metafoo.de>
 <20120801092625.GB21303@liondog.tnic>
 <5018F908.9090607@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5018F908.9090607@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2012 at 11:38:16AM +0200, Lars-Peter Clausen wrote:
> You don't see any drivers, because the subsystem is still young and no
> such arch independent drivers have been added yet, but they will get
> added in the future. The arch independent companion or PWM expander
> chips usually interface via I2S or SPI and I would consider it quite
> likely that you'll also find them on some embedded X86 boards. If we
> add a arch restriction to the config item now we'd quite likely have
> to remove it again in the next release.

Yes please.

Kconfig is overcrowded as it is now and adding yet another option which
is irrelevant for some arches (for now, as you say) simply causes
confusion to people with absolutely no gain.

Simply take a look at all arch/<archname>/Kconfig files and look at all
the "select ..." statements right at the beginning of the respective
Kconfig file.

Each arch which has PWM drivers would select the synthetic
CONFIG_ARCH_PWM option and CONFIG_PWM would depend on it.

-- 
Regards/Gruss,
    Boris.
