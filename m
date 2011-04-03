Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246Ab1DCMZA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 08:25:00 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46504 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752172Ab1DCMY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 08:24:59 -0400
Subject: Re: accessing vfpinstr macros from outside vfp directory
From: Will Deacon <will.deacon@arm.com>
To: Bryan Huntsman <bryanh@codeaurora.org>
Cc: Neil Leeder <nleeder@codeaurora.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jean Pihet <jean.pihet@newoldbits.com>,
        Sheetal Sahasrabudhe <sheetals@codeaurora.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, jamie.iles@picochip.com,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <4D96499B.5070402@codeaurora.org>
References: <4D924966.2050707@codeaurora.org>
	 <1301678843.17592.5.camel@e102144-lin.cambridge.arm.com>
	 <4D96499B.5070402@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 03 Apr 2011 13:24:40 +0100
Message-ID: <1301833480.5022.11.camel@jazzbox>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bryan,

On Fri, 2011-04-01 at 22:54 +0100, Bryan Huntsman wrote:
> On 04/01/11 10:27, Will Deacon wrote:
> > Neil,
> >
> > On Tue, 2011-03-29 at 22:04 +0100, Neil Leeder wrote:
> >> Any opinions on what would be the best thing to do here? Choices
> appear to be:
> >>
> >> 1) allow the relative include path of ../vfp/vfpinstr.h
> >> 2) move the definitions of fmrx, fmxr from vfp/vfpinstr.h to
> include/asm/vfp.h
> >> 3) move vfp/vfpinstr.h to include/asm
> >> 4) other...?
> >>
> >> If it helps, I can create a patch for whichever is considered the
> preferred solution.
> >>
> >
> > I personally don't find option (1) that offensive - Bryan seemed to
> > differ though so perhaps option (2) would keep him happy?
> >
> > I don't think option (3) is sensible given that the majority of the
> > header file is private to /vfp.
> >
> > Will
> 
> I raised it as a question.  If that's the only sane thing to do here,
> then do it.  Since no one else seems to have chimed in on (2) or (3),
> I'm fine with the patch as-is.

Ok, great. Let's leave it like it is for the time-being and if other
people start using things from the vfp headers then we should consider
refactoring some of that code (currently I think it's restricted to this
patch series and some files under vfp/).

Cheers,

Will

