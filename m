Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597Ab1JNGvE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 02:51:04 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:40455 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119Ab1JNGvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 02:51:01 -0400
Subject: Re: [PATCH v8]: Improve performance of LZO/plain hibernation
Date: Fri, 14 Oct 2011 17:50:54 +1100
From: "Bojan Smojver" <bojan@rexursive.com>
To: penberg@cs.helsinki.fi
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        keithp@keithp.com
MIME-Version: 1.0
X-Mailer: LCG ProfiMail 3.48
Message-ID: <0123092430.1003081854@rexursive.com>
References: <1317342456.1959.6.camel@shrek.rexursive.com> <201110062045.48689.rjw@sisk.pl> <2409186928.1003010428@rexursive.com> <201110132326.02041.rjw@sisk.pl> <1318557712.2027.1.camel@shrek.rexursive.com> <CAOJsxLF2Qo0UK8wCg1mt2Awiv7k=XPA9kHMy808f++FXibi4QA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------- Original message -------
> From: Pekka Enberg

> What debugging options do you have enabled?

Not sure to be honest. Just copied Fedora kernel config file and built with 
that. Will check.

> Bojan, this is with Intel drivers, right?

Correct. But note that I had similar trouble on a box that has radeon 
graphics. Essentially, if I pass nomodeset to the kernel, I can hibernate 
thaw 100+ times with no issues (after all these cycles, the box is healthy, 
runs programs with no trouble etc.).

> I'm CC'ing Keith which might
> be able to give some clues how to debug KMS related hibernate/thaw
> issues.

I am already on intel-gfx list where I asked the same questions, got some 
suggestions and eventually opened a bug to track the issue. My last message 
to that list was that I think the problem may be in common KMS code, given 
I get similar touble with intel and radeon graphics, 32 and 64 bit machines 
and with or without my patch.

--
Bojan 
