Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932504Ab1EYHk7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 03:40:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36203 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754666Ab1EYHk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 03:40:58 -0400
Date: Wed, 25 May 2011 09:40:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: James Morris <jmorris@namei.org>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: SLUB regression in current Linus
Message-ID: <20110525074040.GA9233@elte.hu>
References: <alpine.LRH.2.00.1105242146240.12134@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1105242146240.12134@tundra.namei.org>
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


* James Morris <jmorris@namei.org> wrote:

> I started experiencing a boot hang in 2.6.39+, and bisected it to this 
> change:

i too was seeing various instabilities and SLUB corruption in -tip testing. 
Every 5th randconfig kernel crashes.

I started testing the revert.

Thanks,

	Ingo
