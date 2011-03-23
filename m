Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716Ab1CWIdR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 04:33:17 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:57214 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755621Ab1CWIdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 04:33:15 -0400
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: "'Stephen Boyd'" <sboyd@codeaurora.org>
Cc: "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>,
        "'Arnd Bergmann'" <arnd@arndb.de>, <linux-kernel@vger.kernel.org>,
        "'Sam Ravnborg'" <sam@ravnborg.org>
References: <1300751462-1494-1-git-send-email-sboyd@codeaurora.org>	<201103220934.50435.arnd@arndb.de>	<20110322092113.GB17264@n2100.arm.linux.org.uk>	<201103221110.20861.arnd@arndb.de>	<00ec01cbe897$2eed7210$8cc85630$@mprc.pku.edu.cn>	<4D88ECE3.1070209@codeaurora.org> <00fc01cbe8f9$cd807640$688162c0$@mprc.pku.edu.cn> <4D896616.7070307@codeaurora.org>
In-Reply-To: <4D896616.7070307@codeaurora.org>
Subject: RE: [PATCH] ARM: Use asm-generic/sizes.h
Date: Wed, 23 Mar 2011 16:30:31 +0800
Message-ID: <016301cbe934$957a69f0$c06f3dd0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQE4tCitO1vWIib0wOPyTOUnpd6PFADDwX3XAptj/h4B/snX1wF+NHZ7ApnGjSYCO2GxCAHuWTdLlPP9uPA=
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Stephen Boyd [mailto:sboyd@codeaurora.org]
> Sent: Wednesday, March 23, 2011 11:17 AM
> To: Guan Xuetao
> Cc: 'Russell King - ARM Linux'; linux-arm-kernel@lists.infradead.org; 'Arnd Bergmann'; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] ARM: Use asm-generic/sizes.h
> 
> On 03/22/2011 06:29 PM, Guan Xuetao wrote:
> >> -----Original Message-----
> >> From: Stephen Boyd [mailto:sboyd@codeaurora.org]
> >> Sent: Wednesday, March 23, 2011 2:40 AM
> >> To: Guan Xuetao
> >> Cc: 'Arnd Bergmann'; linux-arm-kernel@lists.infradead.org; 'Russell King - ARM Linux'; linux-kernel@vger.kernel.org
> >> Subject: Re: [PATCH] ARM: Use asm-generic/sizes.h
> >> Ah, I didn't notice this part. SZ_48M is actually used by ARM code so
> >> that would need to be added to the generic header should we go with this
> >> patch.
> > IMO, the content of asm-generic/sizes.h should only include power-of-2 sizes definitions.
> > And SZ_48M could be replaced by (SZ_32M | SZ_16M) or (SZ_32M + SZ_16M), or added to arch-specific headers.
> >
> >
> 
> I'm hoping that kbuild gets asm-generic support sometime soon so files
> with only a "#include <asm-generic/*>" are generated instead of living
> in the tree. In that case I'd rather have the non power of 2 constants
> added to the generic sizes.h and be done with it. There isn't any strong
> technical reason to deny power of 2 constants from the generic header,
> right?
No.
I just think that power-of-2 sizes are more generic, not compulsively of course.

Sam Ravnborg had introduced a patch set to provide generic support for
architectures that using one-line asm-generic headers.

CC: Sam Ravnborg <sam@ravnborg.org>

> 
> Note: SH could also move to this if SZ_26M is put in the generic header.
> 
> --
> Sent by an employee of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

