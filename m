Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758798Ab2CVSkq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 14:40:46 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39068 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758713Ab2CVSkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 14:40:43 -0400
Message-ID: <4F6B7226.8000102@wwwdotorg.org>
Date: Thu, 22 Mar 2012 12:40:38 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: Russell King <linux@arm.linux.org.uk>, nico@fluxnic.net,
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
References: <1331931835-12346-1-git-send-email-swarren@wwwdotorg.org>
In-Reply-To: <1331931835-12346-1-git-send-email-swarren@wwwdotorg.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2012 03:03 PM, Stephen Warren wrote:
> All ARCHs have the same definition of MKIMAGE. Move it to Makefile.lib
> to avoid duplication.
> 
> All ARCHs have similar definitions of cmd_uimage. Place a sufficiently
> parameterized version in Makefile.lib to avoid duplication.

Michal,

Does this change look reasonable? It has acks from people working on 4
of the 7 affected architectures; would you prefer acks from all?

Thanks.
