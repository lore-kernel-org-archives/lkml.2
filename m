Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760354Ab1LPR7o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 12:59:44 -0500
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:23802
	"EHLO DB3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756517Ab1LPR7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 12:59:39 -0500
X-SpamScore: -5
X-BigFish: VS-5(zzbb2dI9371I98dKzz1202hzzz2dh2a8h668h839h93fh)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 13,
Message-ID: <4EEB8704.8030201@freescale.com>
Date: Fri, 16 Dec 2011 11:59:32 -0600
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: LiuShuo <b35362@freescale.com>
CC: <dedekind1@gmail.com>, <shuo.liu@freescale.com>, <dwmw2@infradead.org>,
        <Artem.Bityutskiy@nokia.com>, <linux-mtd@lists.infradead.org>,
        <linuxppc-dev@lists.ozlabs.org>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <leoli@freescale.com>
Subject: Re: [PATCH 3/3] mtd/nand : workaround for Freescale FCM to support
 large-page Nand chip
References: <1322973098-2528-1-git-send-email-shuo.liu@freescale.com>   <1322973098-2528-3-git-send-email-shuo.liu@freescale.com>   <4EDEAEB9.6020703@freescale.com> <1323724195.2297.11.camel@koala>  <4EE66EFE.1050608@freescale.com> <1323724784.2297.20.camel@koala> <4EE6725C.3050706@freescale.com> <4EE6BC9B.4000602@freescale.com> <4EE8612C.9050104@freescale.com> <4EE903CE.1010903@freescale.com> <4EEAB076.30000@freescale.com>
In-Reply-To: <4EEAB076.30000@freescale.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2011 08:44 PM, LiuShuo wrote:
> hi Artem,
> Could this patch be applied now and we make a independent patch for  bad
> block information
> migration later?

This patch is not safe to use without migration.

-Scott

