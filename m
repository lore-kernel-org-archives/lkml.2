Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378Ab2GaR0m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 13:26:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11434 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026Ab2GaR0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 13:26:40 -0400
X-Authority-Analysis: v=2.0 cv=IOWA+3TG c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=wom5GMh1gUkA:10 a=aqDLzf-sAsEA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=MOAlSWJXwOALvgJcYAAA:9 a=CjuIK1q_8ugA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Date: Tue, 31 Jul 2012 13:26:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Borislav Petkov <bp@alien8.de>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: awful kconfig help texts.
Message-ID: <20120731172638.GE16873@home.goodmis.org>
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

Then shouldn't this not have a prompt and just be selected by those
PWM drivers below?


> 
> Got it? :-)
> 
> > I'm picking on PWM here, but this isn't an
> > isolated case.  Every merge window we see a slew of new options with useless
> > help texts. They may as well be non-existent. (Actually in some cases, they are).
> > 
> > If someone has to read the code to find out what the driver is, your help text probably sucks.
> > 
> > 
> > (I'll leave "why does this option even show up on x86" as a separate rant)

/me is looking forward to this rant ;-)

-- Steve

