Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188Ab0E3V7A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 17:59:00 -0400
Received: from s12.ALPHA-c2.vectant.ne.jp ([222.230.51.12]:51469 "EHLO
	s12.ALPHA-c2.vectant.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755101Ab0E3V67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 17:58:59 -0400
Message-Id: <201005302158.AA00414@tamuki.linet.gr.jp>
From: TAMUKI Shoichi <tamuki@linet.gr.jp>
Date: Mon, 31 May 2010 06:58:16 +0900
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Anton Blanchard <anton@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Andy Green <andy@warmcat.com>, TAMUKI Shoichi <tamuki@linet.gr.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] panic: keep blinking in spite of long spin timer mode
In-Reply-To: <20100528152241.4f5db28f.randy.dunlap@oracle.com>
References: <20100528152241.4f5db28f.randy.dunlap@oracle.com>
MIME-Version: 1.0
X-Mailer: AL-Mail32 Version 1.13
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Thank you for your comment.

On Fri, 28 May 2010 15:22:41 -0700 Randy Dunlap wrote:

> > +	panicblink=	[KNL] The speed of panic blink (default is 12 wpm)
> 
> What is "wpm"?  In typing, it's words per minute.
> Is it "winks per minute" here?  If not, what?

Yes, it's words per minute.  "wpm" here is analogized to the speed of
morse code and is thought natural and reasonable as an indicator of the
speed of blinking.

The period of panic blink can be computed by the formula T = 7200 / W,
where T is the period in milliseconds, W is the speed in wpm.

Anyway, not to be confused, I will add two lines of the above-mentioned
to kernel-parameters.txt in the PATCH v2.

Regards,
TAMUKI Shoichi
