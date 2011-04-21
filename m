Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424Ab1DUCRJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 22:17:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:61410 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab1DUCRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 22:17:08 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=MvxcOw6unBcA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=LRdWIEW7jnhDvEgRHdIA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] ftrace: Build without frame pointers on Microblaze
From: Steven Rostedt <rostedt@goodmis.org>
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
In-Reply-To: <4DA698BA.6020506@monstr.eu>
References: <1301908812-8119-1-git-send-email-monstr@monstr.eu>
	 <1301908812-8119-2-git-send-email-monstr@monstr.eu>
	 <4DA698BA.6020506@monstr.eu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 20 Apr 2011 22:17:06 -0400
Message-ID: <1303352226.7181.109.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-14 at 08:48 +0200, Michal Simek wrote:
> Hi Ingo, [cc: Steven and Frederic]
> 
> can you please add this patch to your tree?
> 

Sorry, I've been traveling and I'm behind on email. I'll queue this up.
Is this needed for 2.6.39 or can it wait to 2.6.40?

-- Steve


