Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677Ab2GaRmt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 13:42:49 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49078 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753587Ab2GaRms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 13:42:48 -0400
Date: Tue, 31 Jul 2012 19:42:49 +0200
From: Borislav Petkov <bp@alien8.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: awful kconfig help texts.
Message-ID: <20120731174249.GB4735@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Steven Rostedt <rostedt@goodmis.org>, Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Thierry Reding <thierry.reding@avionic-design.de>
References: <20120731151600.GA19412@redhat.com>
 <20120731170741.GA4735@x1.osrc.amd.com>
 <20120731172638.GE16873@home.goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120731172638.GE16873@home.goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 01:26:38PM -0400, Steven Rostedt wrote:
> Then shouldn't this not have a prompt and just be selected by those
> PWM drivers below?

It gives an empty menu due to the deps of the single PWM drivers.

But the whole CONFIG_PWM thing should simply depend on !X86 so that it
doesn't appear in drivers/.

-- 
Regards/Gruss,
Boris.
