Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932511Ab2CZNsv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 09:48:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41162 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757248Ab2CZNst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 09:48:49 -0400
Message-ID: <4F7073BA.6040403@suse.cz>
Date: Mon, 26 Mar 2012 15:48:42 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Russell King <linux@arm.linux.org.uk>, nico@fluxnic.net,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Mike Frysinger <vapier@gentoo.org>, Michal Simek <monstr@monstr.eu>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        uclinux-dist-devel@blackfin.uclinux.org,
        microblaze-uclinux@itee.uq.edu.au, linux-sh@vger.kernel.org,
        sparclinux@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH] Kbuild: centralize MKIMAGE and cmd_uimage definitions
References: <1331931835-12346-1-git-send-email-swarren@wwwdotorg.org> <4F6B7226.8000102@wwwdotorg.org>
In-Reply-To: <4F6B7226.8000102@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.3.2012 19:40, Stephen Warren wrote:
> On 03/16/2012 03:03 PM, Stephen Warren wrote:
>> All ARCHs have the same definition of MKIMAGE. Move it to Makefile.lib
>> to avoid duplication.
>>
>> All ARCHs have similar definitions of cmd_uimage. Place a sufficiently
>> parameterized version in Makefile.lib to avoid duplication.
> 
> Michal,
> 
> Does this change look reasonable?

Absolutely.

> It has acks from people working on 4
> of the 7 affected architectures; would you prefer acks from all?

I will apply it now.

Michal
