Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab2BWHdJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 02:33:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33153 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753931Ab2BWHdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 02:33:07 -0500
Date: Thu, 23 Feb 2012 08:32:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Randy Dunlap <rdunlap@xenotime.net>,
        Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/5] x86: Cleanup and simplify cpu-specific data
Message-ID: <20120223073255.GA15306@elte.hu>
References: <20120222092745.GA30339@elte.hu>
 <1329953551-17074-1-git-send-email-kjwinchester@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329953551-17074-1-git-send-email-kjwinchester@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Kevin Winchester <kjwinchester@gmail.com> wrote:

>  22 files changed, 91 insertions(+), 190 deletions(-)

Btw., the diffstat is very nice - the individual patches only 
hinted at the simplification effect - the combined diffstat 
shows that we saved a hundred lines of often rather complex code 
and made this code quite a bit more hackable.

Thanks,

	Ingo
