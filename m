Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419Ab2CKXCH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 19:02:07 -0400
Received: from nctlincom01.orcon.net.nz ([60.234.4.74]:42474 "EHLO
	nctlincom01.orcon.net.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754339Ab2CKXCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 19:02:03 -0400
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Michel Lespinasse" <walken@google.com>
Message-Id: <679A8D73-6496-46D4-B7AC-E83C404F63DA@orcon.net.nz>
From: Michael Cree <mcree@orcon.net.nz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <C6gS2DkSgiG.A.AyB.6tRXPB@chimera>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: [Bug #42821] alpha: futex regression bisected
Date: Mon, 12 Mar 2012 11:49:48 +1300
References: <WuYv90FoNpB.A.O8.ktRXPB@chimera> <C6gS2DkSgiG.A.AyB.6tRXPB@chimera>
X-Mailer: Apple Mail (2.936)
X-DSPAM-Check: by mx3.orcon.net.nz on Mon, 12 Mar 2012 12:02:00 +1300
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Mon Mar 12 12:02:00 2012
X-DSPAM-Confidence: 0.6511
X-DSPAM-Probability: 0.0000
X-Bayes-Prob: 0.0001 (Score 0, tokens from: @@RPTN, default)
X-Spam-Score: 0.00 () [Hold at 5.00] 
X-CanIt-Geo: ip=130.217.188.11; country=NZ; latitude=-41.0000; longitude=174.0000; http://maps.google.com/maps?q=-41.0000,174.0000&z=6
X-CanItPRO-Stream: base:default
X-Canit-Stats-ID: 06GIn1wf0 - da5c57a761fa - 20120312
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2012, at 10:31 AM, Rafael J. Wysocki wrote:
> Bug-Entry	: https://bugzilla.kernel.org/show_bug.cgi?id=42821
> Subject		: alpha: futex regression bisected
> Submitter	: Michael Cree <mcree@orcon.net.nz>
> Date		: 2012-02-20 8:20 (21 days old)
> First-Bad-Commit: http://git.kernel.org/linus/8d7718aa082aaf30a0b4989e1f04858952f941bc
> Message-ID	: <4F420256.2090600@orcon.net.nz>
> References	: http://marc.info/?l=linux-kernel&m=132972606917069&w=2

Fixed in 3.3-rc7 by commit 62aca403657fe30e5235c5331e9871e676d9ea0a.

Cheers
Michael.

