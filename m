Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab1A1KOj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 05:14:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2117 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754244Ab1A1KOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 05:14:38 -0500
From: Andreas Schwab <schwab@redhat.com>
To: "David Laight" <David.Laight@ACULAB.COM>
Cc: "David Daney" <ddaney@caviumnetworks.com>,
        "Coly Li" <bosong.ly@taobao.com>, Wang Cong <xiyou.wangcong@gmail.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Yong Zhang <yong.zhang0@gmail.com>
Subject: Re: [PATCH 2/7] PowerPC: add unlikely() to BUG_ON()
References: <4D41B213.4070606@caviumnetworks.com>
	<AE90C24D6B3A694183C094C60CF0A2F6D8AC2D__37237.0892241181$1296205746$gmane$org@saturn3.aculab.com>
X-Yow: Clear the laundromat!!  This whirl-o-matic just had a nuclear meltdown!!
Date: Fri, 28 Jan 2011 11:14:16 +0100
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6D8AC2D__37237.0892241181$1296205746$gmane$org@saturn3.aculab.com>
	(David Laight's message of "Fri, 28 Jan 2011 09:05:59 -0000")
Message-ID: <m31v3xxrlz.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"David Laight" <David.Laight@ACULAB.COM> writes:

> Also, as (I think) in some of the generated code quoted,
> use of __builtin_expect() with a boolean expression can
> force some versions of gcc to generate the integer
> value of the expression

That's more likely a side effect of the definition of likely/unlikely:
they expand to !!(x).

Andreas.

-- 
Andreas Schwab, schwab@redhat.com
GPG Key fingerprint = D4E8 DBE3 3813 BB5D FA84  5EC7 45C6 250E 6F00 984E
"And now for something completely different."
