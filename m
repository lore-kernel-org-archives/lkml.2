Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab1CWBcW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 21:32:22 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:39824 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752981Ab1CWBcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 21:32:20 -0400
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: "'Stephen Boyd'" <sboyd@codeaurora.org>
Cc: "'Arnd Bergmann'" <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>,
        "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>
References: <1300751462-1494-1-git-send-email-sboyd@codeaurora.org> <201103220934.50435.arnd@arndb.de> <20110322092113.GB17264@n2100.arm.linux.org.uk> <201103221110.20861.arnd@arndb.de> <00ec01cbe897$2eed7210$8cc85630$@mprc.pku.edu.cn> <4D88ECE3.1070209@codeaurora.org>
In-Reply-To: <4D88ECE3.1070209@codeaurora.org>
Subject: RE: [PATCH] ARM: Use asm-generic/sizes.h
Date: Wed, 23 Mar 2011 09:29:46 +0800
Message-ID: <00fc01cbe8f9$cd807640$688162c0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQE4tCitO1vWIib0wOPyTOUnpd6PFADDwX3XAptj/h4B/snX1wF+NHZ7ApnGjSaVFNrB0A==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Stephen Boyd [mailto:sboyd@codeaurora.org]
> Sent: Wednesday, March 23, 2011 2:40 AM
> To: Guan Xuetao
> Cc: 'Arnd Bergmann'; linux-arm-kernel@lists.infradead.org; 'Russell King - ARM Linux'; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] ARM: Use asm-generic/sizes.h
> 
> On 03/22/2011 06:43 AM, Guan Xuetao wrote:
> > And I just complete the SZ_* definitions for 32-bit architecture,
> > and remove SZ_48M for not being power-of-2 size.
> 
> Ah, I didn't notice this part. SZ_48M is actually used by ARM code so
> that would need to be added to the generic header should we go with this
> patch.

IMO, the content of asm-generic/sizes.h should only include power-of-2 sizes definitions.
And SZ_48M could be replaced by (SZ_32M | SZ_16M) or (SZ_32M + SZ_16M), or added to arch-specific headers.

Guan Xuetao

