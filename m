Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab1FNAhR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 20:37:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:35791 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755313Ab1FNAhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 20:37:16 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=1ZhljathgHUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=J5f1eJ2kQfa3O2YAk3gA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 03/15] tracing: Add a free on close control mechanism
 for buffer_size_kb
From: Steven Rostedt <rostedt@goodmis.org>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <BANLkTikssQhJu3t=ikpbq11oGeV2D3L-Zc1TuVW0+TKBqmkXyw@mail.gmail.com>
References: <20110609172744.333794089@goodmis.org>
	 <20110609172910.950101158@goodmis.org> <20110613101248.GC30962@elte.hu>
	 <1307965185.9218.53.camel@gandalf.stny.rr.com>
	 <20110613114904.GD10960@elte.hu>
	 <1307966043.9218.63.camel@gandalf.stny.rr.com>
	 <BANLkTikssQhJu3t=ikpbq11oGeV2D3L-Zc1TuVW0+TKBqmkXyw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 13 Jun 2011 20:37:15 -0400
Message-ID: <1308011835.9218.104.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-13 at 13:01 -0700, Vaibhav Nagarnaik wrote:

> I have created the patch.
> 
> I was wondering what would you consider a good name for the new proc
> file? David suggested "free_ring_buffer".

Since we already have a "buffer_size" "free_buffer" should be a good
name.

-- Steve


