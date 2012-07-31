Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab2GaTMp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 15:12:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5368 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286Ab2GaTMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 15:12:42 -0400
Date: Tue, 31 Jul 2012 14:43:13 -0400
From: Dave Jones <davej@redhat.com>
To: Borislav Petkov <bp@alien8.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: awful kconfig help texts.
Message-ID: <20120731184313.GA30493@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Thierry Reding <thierry.reding@avionic-design.de>
References: <20120731151600.GA19412@redhat.com>
 <20120731170741.GA4735@x1.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120731170741.GA4735@x1.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 07:07:41PM +0200, Borislav Petkov wrote:
 > On Tue, Jul 31, 2012 at 11:16:00AM -0400, Dave Jones wrote:
 > > 
 > > PWM Support (PWM) [N/y/?] (NEW) ?
 > > 
 > > CONFIG_PWM:
 > > 
 > > This enables PWM support through the generic PWM framework.
 > > 
 > > 
 > > Well that's.. enlightening.
 > 
 > Oh, there's one more enlightening sentence in the help:
 > 
 > "You only need to enable this, if you also want to enable one or more of
 > the PWM drivers below."
 > 
 > Got it? :-)

No, it doesn't add anything useful at all.

I know PWM is probably pulse width modulation, but why would my kernel
need to care about this ? Why would I need drivers for it ?

Also, think about what happens with 'oldconfig'. You don't get to even
see 'the drivers below' until you've answered this question.

It couldn't be more opaque if it tried.

	Dave
 
