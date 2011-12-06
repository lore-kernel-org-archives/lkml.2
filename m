Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab1LFTQp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 14:16:45 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40261 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753774Ab1LFTQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 14:16:43 -0500
Date: Tue, 6 Dec 2011 20:14:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/locking] lockdep, rtmutex, bug: Show taint flags on
 error
Message-ID: <20111206191458.GA25568@elte.hu>
References: <1319773015.6759.30.camel@deadeye>
 <tip-fbdc4b9a6c29befbcca65e5366e5aaf2abb7a013@git.kernel.org>
 <1323185640.7454.269.camel@deadeye>
 <1323193731.32012.81.camel@twins>
 <20111206175558.3215907c@lxorguk.ukuu.org.uk>
 <20111206175919.GA5386@elte.hu>
 <20111206181715.GG3366@decadent.org.uk>
 <20111206182847.GB12094@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111206182847.GB12094@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Anyway, SOB flaming aside, i think there's now consensus that we 
don't want to disable lockdep for TAINT_OOT modules.

Mind (re-)sending a delta patch against tip:master that excludes 
that taint flag in addition to the already excluded 
TAINT_FIRMWARE case? That should close this rather verbose 
chapter of taint flag handling changes for good ;-)

Thanks,

	Ingo
