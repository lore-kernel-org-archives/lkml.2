Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab1HWSiW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 14:38:22 -0400
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:12833
	"EHLO VA3EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752684Ab1HWSiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 14:38:18 -0400
X-SpamScore: -8
X-BigFish: VS-8(zz1b0bM98dKzz1202hzz8275bhz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4E53F392.1080702@freescale.com>
Date: Tue, 23 Aug 2011 13:38:10 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20110429 Fedora/3.6.17-1.fc13 Firefox/3.6.17
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <kernel-janitors@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 8/9] arch/powerpc/sysdev/ehv_pic.c: add missing kfree
References: <1312802283-9107-8-git-send-email-julia@diku.dk>
In-Reply-To: <1312802283-9107-8-git-send-email-julia@diku.dk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall wrote:
> At this point, ehv_pic has been allocated but not stored anywhere, so it
> should be freed before leaving the function.

Acked-by: Timur Tabi <timur@freescale.com>

FYI, Ashish is no longer with Freescale, so I've taken over maintainership of
ehv_pic.

-- 
Timur Tabi
Linux kernel developer at Freescale

