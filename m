Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab0HSTGw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 15:06:52 -0400
Received: from n15.bullet.mail.mud.yahoo.com ([68.142.206.42]:38830 "HELO
	n15.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752937Ab0HSTGu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 15:06:50 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 221921.44396.bm@omp310.mail.re3.yahoo.com
Message-ID: <85878.24188.qm@web84204.mail.re3.yahoo.com>
X-YMail-OSG: qotMQ8cVM1k9k2nh4OmQLQLhXQOR4tU5EX7KnGPFvO5BsQD
 33kH4fjAEpdIMWYibrkXUiq6NfIUv3k56g3kI6vMsNHh3s83n.mTxKEyKjrS
 iU2zjRCvETr_GHYSU47q9cSMXsPXDTxSFWu79Ed7485.SJcL4MUulIE5c9ZC
 zmtx1DSSWnzOycJ0VQOyLKZdOfnXqyVtkp88ueKO7BWJmWSImPHeBdlaXKlD
 M1UyrAeXkgRwkC.CIz8DkhvoZnS3wb1goIjvI.XQUnai8ONuzs7elLDqFVbr
 yjwzPgQ98g8ZjsBWGVHiVSuSCE.iGL5afO1I.DlAka3T2ten.SlY2fdY7Lsl
 OoO_l0t7wEDfa_Q--
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Thu, 19 Aug 2010 12:06:49 -0700 (PDT)
From: "D. Stussy" <kd6lvw@verizon.net>
Subject: Re: [tip:x86/urgent] x86, asm: Refactor atomic64_386_32.S to support old binutils and be cleaner
To: linux-tip-commits@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, luca@luca-barbieri.com,
        tglx@linutronix.de
In-Reply-To: <tip-30246557a06bb20618bed906a06d1e1e0faa8bb4@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Has this patch been posted to the 2.6.35 kernel also, or just to 2.6.36?  I don't think it's been posted to 2.6.35 where the problem it corrects was introduced.

"Greg KH" <gregkh@suse.de> has made a last call (tomorrow - Aug 20) for chnges for 2.6.35.3 and doesn't seem to have this.  It's not in the prior two updates either.....

--- On Wed, 8/11/10, tip-bot for Luca Barbieri <luca@luca-barbieri.com> wrote:
> Commit-ID:  30246557a06bb20618bed906a06d1e1e0faa8bb4
> Gitweb:     http://git.kernel.org/tip/30246557a06bb20618bed906a06d1e1e0faa8bb4
> Author:     Luca Barbieri <luca@luca-barbieri.com>
> AuthorDate: Fri, 6 Aug 2010 04:04:38 +0200
> Committer:  H. Peter Anvin <hpa@zytor.com>
> CommitDate: Wed, 11 Aug 2010 21:03:28 -0700
> 
> x86, asm: Refactor atomic64_386_32.S to support old
> binutils and be cleaner
> 
> The old code didn't work on binutils 2.12 because setting a symbol to
> a register apparently requires a fairly recent version.
> 
> ...
> 
> This fixes kernel bugzilla 16506.
...

