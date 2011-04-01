Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252Ab1DAGXp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 02:23:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60389 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753613Ab1DAGXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 02:23:44 -0400
Date: Fri, 1 Apr 2011 08:23:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, yinghai@kernel.org,
        linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
        lkml20101129@newton.leun.net
Subject: Re: [PATCH urgent] x86: Save cr4 to mmu_cr4_features at boot time
Message-ID: <20110401062338.GA6434@elte.hu>
References: <alpine.DEB.2.00.1103311715400.16492@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1103311715400.16492@kaball-desktop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stefano Stabellini <stefano.stabellini@eu.citrix.com> wrote:

> Save cr4 to mmu_cr4_features at boot time
> 
> This patch fixes a freeze when resuming from hibernation, introduced by
> "x86: Cleanup highmap after brk is concluded", commit id
> e5f15b45ddf3afa2bbbb10c7ea34fb32b6de0a0e.
> This patch should be backported to all the stable tree where the
> offending commit is present.

No, the offending commit should be reverted from -stable. It's not at all clear 
yet why this fix patch helps.

Thanks,

	Ingo
