Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758589Ab1DAR2J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 13:28:09 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:61992 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758468Ab1DAR2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 13:28:07 -0400
Subject: Re: accessing vfpinstr macros from outside vfp directory
From: Will Deacon <will.deacon@arm.com>
To: Neil Leeder <nleeder@codeaurora.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jean Pihet <jean.pihet@newoldbits.com>,
        Sheetal Sahasrabudhe <sheetals@codeaurora.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, jamie.iles@picochip.com,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <4D924966.2050707@codeaurora.org>
References: <4D924966.2050707@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Apr 2011 18:27:23 +0100
Message-ID: <1301678843.17592.5.camel@e102144-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neil,

On Tue, 2011-03-29 at 22:04 +0100, Neil Leeder wrote:
> Any opinions on what would be the best thing to do here? Choices appear to be:
> 
> 1) allow the relative include path of ../vfp/vfpinstr.h
> 2) move the definitions of fmrx, fmxr from vfp/vfpinstr.h to include/asm/vfp.h
> 3) move vfp/vfpinstr.h to include/asm
> 4) other...?
> 
> If it helps, I can create a patch for whichever is considered the preferred solution.
> 

I personally don't find option (1) that offensive - Bryan seemed to
differ though so perhaps option (2) would keep him happy?

I don't think option (3) is sensible given that the majority of the
header file is private to /vfp.

Will

