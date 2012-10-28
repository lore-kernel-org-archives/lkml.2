Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab2J1CKR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 22:10:17 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:59573 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038Ab2J1CKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 22:10:15 -0400
Message-ID: <508C9405.5030600@wwwdotorg.org>
Date: Sat, 27 Oct 2012 20:10:13 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Michal Marek <mmarek@suse.cz>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>, Jon Loeliger <jdl@jdl.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Scott Wood <scottwood@freescale.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V4 REPOST 2/2] kbuild: run the pre-processor on *.dts
 files
References: <1351279797-16450-1-git-send-email-swarren@wwwdotorg.org> <1351279797-16450-2-git-send-email-swarren@wwwdotorg.org> <508AEB3E.6090405@gmail.com> <20121027220638.GK4564@opensource.wolfsonmicro.com> <fb065651-fd9d-4435-9a61-884dcb1da8d0@email.android.com>
In-Reply-To: <fb065651-fd9d-4435-9a61-884dcb1da8d0@email.android.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2012 07:06 PM, Rob Herring wrote:
> Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> 
>     On Fri, Oct 26, 2012 at 02:57:50PM -0500, Rob Herring wrote:
> 
>         Like I said previously, I think we first need guidelines on what
>         is and
>         isn't acceptable use of C preprocessor in dts files.
> 
> 
>     Didn't we already say that it was just the same rules as for things tht
>     get included in .S files?  Besides for plain .dts files (as opposed to
>     .dtsi files) it seems like if people break things they get to keep all
>     the pieces without disrupting other people too much.
> 
> 
> Yes, but can we document that. Also, I'd like others with more DT
> historical knowledge to weigh in.

OK. What's the appropriate file to document that in? I assume you're not
just looking for an explanation in the commit description?

