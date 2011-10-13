Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817Ab1JMOgW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 10:36:22 -0400
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:7782
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755574Ab1JMOgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 10:36:21 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 0,13,
Message-ID: <4E96F723.2010304@freescale.com>
Date: Thu, 13 Oct 2011 09:35:15 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20110429 Fedora/3.6.17-1.fc13 Firefox/3.6.17
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Kumar Gala <galak@kernel.crashing.org>, "Hans J. Koch" <hjk@hansjkoch.de>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiang Kai-B18973 <B18973@freescale.com>
Subject: Re: [PATCH] uio: Support 36-bit physical addresses on 32-bit systems
References: <1318430145-19898-1-git-send-email-galak@kernel.crashing.org>	<20111012153229.GB21852@local>	<AD39F4F8-E9C0-4090-9AEA-644F82DD328B@kernel.crashing.org>	<CAMuHMdU1rHDvZEknNqKLHyBmJ26kH7SJtxsOZmOysrSzg6bz4g@mail.gmail.com>	<CAOZdJXVLhe3aNM669sRFmDpHGCVRrP_93xdDwsY9R2VzHUZ-eQ@mail.gmail.com> <CAMuHMdVYsMj99jTJRj_NJ_dCg+b-39ExnDD1Mhqnv3R6tWf1iQ@mail.gmail.com>
In-Reply-To: <CAMuHMdVYsMj99jTJRj_NJ_dCg+b-39ExnDD1Mhqnv3R6tWf1iQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:

> You deleted this part:
> 
> config PHYS_ADDR_T_64BIT
>        def_bool 64BIT || ARCH_PHYS_ADDR_T_64BIT
> 
> which enforces that PHYS_ADDR_T_64BIT is enabled if 64BIT is set.

Ok, I didn't catch that before, but it makes sense now.  Thanks.

-- 
Timur Tabi
Linux kernel developer at Freescale

