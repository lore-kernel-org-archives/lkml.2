Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273Ab1EUK1Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 06:27:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51735 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193Ab1EUK1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 06:27:23 -0400
Date: Sat, 21 May 2011 12:27:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>, x86@kernel.org
Subject: Re: [PATCH 10/12] X86: Move alloc_intr_gate out of line
Message-ID: <20110521102712.GA21114@elte.hu>
References: <1305936082-21304-1-git-send-email-andi@firstfloor.org>
 <1305936082-21304-10-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305936082-21304-10-git-send-email-andi@firstfloor.org>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> This saves about 2.5k text on a non force inline kernel.

Please fix the subject line, there's two problems with it and you are not a 
newbie to have others fix it for you.

Thanks,

	Ingo
