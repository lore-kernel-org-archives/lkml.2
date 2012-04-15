Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615Ab2DOQf5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 12:35:57 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:44806 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106Ab2DOQf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 12:35:56 -0400
Message-ID: <1334507752.2723.3.camel@lorien2>
Subject: Re: [PATCH RESEND] LEDS-One-Shot-Timer-Trigger-implementation
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: Richard Purdie <richard.purdie@linuxfoundation.org>
Cc: shuahkhan@gmail.com, akpm@linux-foundation.org, neilb@suse.de,
        LKML <linux-kernel@vger.kernel.org>
Date: Sun, 15 Apr 2012 10:35:52 -0600
In-Reply-To: <1334064283.10826.6.camel@ted>
References: <1333310039.2879.4.camel@lorien2> <1334064283.10826.6.camel@ted>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Having looked at the code and read through the thread and Andrew's patch
> review, I'm left wondering why you didn't add a new trigger for this
> functionality?
> 
> The reason I ask that there do seem to be a number of questions about
> backwards compatibility and this also seems to complicate the standard
> timer trigger in non-obvious ways. Having a new trigger for this
> functionality would allow for a much clearer namespace and no backwards
> compatibility issues. It also means additional functionality can be
> added later in a contained place. I'm wondering if there is a downside
> to a separate trigger I'm missing?

I finally :) understand your question about why I didn't add a new
trigger. I don't see any reason why I should a new trigger should not be
added and it does make it clean without no backwards compatibility
issues. I will get working on that and get back to you.

Thanks,
-- Shuah

