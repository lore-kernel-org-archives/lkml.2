Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab1HBNYG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 09:24:06 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:37155 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752096Ab1HBNYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 09:24:00 -0400
From: Richard Weinberger <richard@nod.at>
To: Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [PATCH] shm: fix a race between shm_exit() and shm_init()
Date: Tue, 2 Aug 2011 15:23:56 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.37.6-0.5-desktop; KDE/4.6.5; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        linux-kernel@vger.kernel.org, Marc Zyngier <maz@misterjones.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        kernel-hardening@lists.openwall.com,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
References: <20110801180151.GA26686@albatros> <CA+55aFw2kHWY1N=ox1er7c-3WL4OA8x0M=Keu7hvAncKUZd1tQ@mail.gmail.com> <20110802124530.GA2543@albatros>
In-Reply-To: <20110802124530.GA2543@albatros>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108021523.56483.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dienstag 02 August 2011 14:45:30 Vasiliy Kulikov wrote:
> Hi,
> 
> Manuel, Richard, Marc - can you test this patch, please?
> 

Works fine. :-)

Tested-by: Richard Weinberger <richard@nod.at>

Thanks,
//richard
