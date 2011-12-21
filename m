Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303Ab1LUPUf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 10:20:35 -0500
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:43012 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753226Ab1LUPUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 10:20:33 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: y8x2ft8VM1lsyXFJDF4fDk2YPKmsCTc.9dg6aRXEQ1K2sq0
 PO7vAwrvO1HcMD_gK9_lmPWFC1yP.U7TLJRzIBTnRAQABMSwlEC6Fb8iBLQL
 LzOALXvOuVOw_5oke9iQnGoNuYkGRwM8iLvjsn6HL1u_6MhUGsWahfLawmZt
 hL882PlFT3iPpeoiH1n8fCpDP_KrlDcmnqahfX1MsrSTRuJjZ5YUYO8OkcwP
 iNgqhaIiJoYFq0PNXZ7fzEQsS8crjE1Nnhq3RRwVnJOREm7vebrPXrGPBUkp
 jJ05zLSYxpNIMFbP3suXZpiymdSpybXblTdCkE4FxG1kVQgFQHF3W0gMOXgR
 m1gi9w.FpIdXIi0KFpqJw02CRffiR3hy.O44oLxDk9OUNow--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 21 Dec 2011 09:20:29 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] slab fixes for 3.2-rc4
In-Reply-To: <CAOJsxLGj+y2UygJLQO4xbxqgY5OcU65RBZg-P7yecNgc6fKZjQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1112210916400.9601@router.home>
References: <alpine.LFD.2.02.1111292001420.4019@tux.localdomain> <CA+55aFz23nN4EALZKf1uptn3a+LKU8wehEnxXO7WA8J5WAyPAQ@mail.gmail.com> <CAOJsxLEHT4D4rfMvWe5iPFpunOaLWZD9fJxbOJ6_qMwt_rd7eg@mail.gmail.com> <alpine.DEB.2.00.1112201016380.21231@router.home>
 <CAOJsxLGj+y2UygJLQO4xbxqgY5OcU65RBZg-P7yecNgc6fKZjQ@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Dec 2011, Pekka Enberg wrote:

> I still don't understand why we'd want separate preempt safe and
> irqsafe variants. It should be enough to have only unsafe and safe
> variants where the latter would always do the right thing.

The effort to make something irqsafe is higher than making it preempt
safe. If that difference is not important then we could just have safe and
unsafe variants. Traditionally counter operations were only preempt safe
though. So making those irqsafe would increse the overhead.




