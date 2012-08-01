Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab2HAJ0a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 05:26:30 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41991 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858Ab2HAJ02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 05:26:28 -0400
Date: Wed, 1 Aug 2012 11:26:25 +0200
From: Borislav Petkov <bp@alien8.de>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Steven Rostedt <rostedt@goodmis.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: awful kconfig help texts.
Message-ID: <20120801092625.GB21303@liondog.tnic>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5018F537.209@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2012 at 11:21:59AM +0200, Lars-Peter Clausen wrote:
> One major reason for the new PWM framework is to be able to support
> arch independent PWM drivers, like those for companion chips with PWM
> capabilities. Restricting the config option to certain architectures
> wouldn't work.

Right,

but when I enable the CONFIG_PWM option on x86, I don't see any drivers
there. So the logical thing to do would be to hide that option on arches
which don't have such chips.

-- 
Regards/Gruss,
    Boris.
