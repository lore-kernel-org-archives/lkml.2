Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341Ab1EWKS7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 06:18:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53150 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257Ab1EWKS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 06:18:58 -0400
Date: Mon, 23 May 2011 12:18:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: "Gustavo F. Padovan" <padovan@profusion.mobi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "maintainer:X86 ARCHITECTURE..." <x86@kernel.org>,
        "open list:AMD IOMMU (AMD-VI)" <iommu@lists.linux-foundation.org>
Subject: Re: [PATCH 3/8] x86: Kill set but not used warning
Message-ID: <20110523101839.GA24674@elte.hu>
References: <1305918786-7239-1-git-send-email-padovan@profusion.mobi>
 <1305918786-7239-2-git-send-email-padovan@profusion.mobi>
 <1305918786-7239-3-git-send-email-padovan@profusion.mobi>
 <20110523101701.GB27867@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110523101701.GB27867@amd.com>
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


* Roedel, Joerg <Joerg.Roedel@amd.com> wrote:

> This is still there. Can you please rebase this patch against
> linus/master and send again?

a better base would be latest -tip:

 http://people.redhat.com/mingo/tip.git/README

as i've already applied some of the changes in:

 6ec5ff4bc3a9: x86: Eliminate various 'set but not used' warnings

Thanks,

	Ingo
