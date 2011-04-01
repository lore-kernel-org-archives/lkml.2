Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068Ab1DATI1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 15:08:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41061 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900Ab1DATI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 15:08:26 -0400
Date: Fri, 1 Apr 2011 21:08:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>,
        "lkml20101129@newton.leun.net" <lkml20101129@newton.leun.net>,
        stable kernel team <stable@kernel.org>
Subject: Re: [PATCH urgent] x86: Save cr4 to mmu_cr4_features at boot time
Message-ID: <20110401190812.GA16830@elte.hu>
References: <alpine.DEB.2.00.1103311715400.16492@kaball-desktop>
 <20110401062338.GA6434@elte.hu>
 <alpine.DEB.2.00.1104011212070.16492@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1104011212070.16492@kaball-desktop>
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

> P.S.
>
> I asked for a backport of e5f15b45ddf3afa2bbbb10c7ea34fb32b6de0a0e to the 
> stable trees because I forgot to add "CC stable@kernel.org" to the commit 
> message and this commit is needed to fix a critical crash on boot on xen.

You are displaying a dangerously amateurish attitude towards quality control 
and you clealy have no idea what it takes to push fixes into -stable.

You forwarded a brand-new, visibly dangerous native kernel commit to -stable 
without Cc:-ing the maintainers and you have caused a native kernel regression 
that way. You are not maintaining the code in question and you have not 
committed the patch in question.

-stable team, please revert this commit. The whole issue obviously needs more 
testing and we'll forward a proper fix once it's available and tested.

	Ingo
