Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab0IFMps (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 08:45:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23149 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417Ab0IFMpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 08:45:47 -0400
Message-ID: <4C84E265.1020402@redhat.com>
Date: Mon, 06 Sep 2010 15:45:25 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Tom Zanussi <tzanussi@gmail.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisb?= =?ISO-8859-1?Q?ecker?= 
	<fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-perf-users@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: disabling group leader perf_event
References: <4C84B088.5050003@redhat.com> <1283772256.1930.303.camel@laptop> <4C84D1CE.3070205@redhat.com> <1283774045.1930.341.camel@laptop> <4C84D77B.6040600@redhat.com> <20100906124330.GA22314@elte.hu>
In-Reply-To: <20100906124330.GA22314@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/06/2010 03:43 PM, Ingo Molnar wrote:
> Yes. The filter engine is a safe, in-kernel interpreted language in the
> making. The C syntax was chosen because it's close to the heart of every
> kernel developer.
>
> It might make sense to bring this concept a few steps further. Looks
> rather complex but also rather cool ...

Is this a roundabout way of saying "jit"?

If so, I'm all for it.  I could use one myself.

-- 
error compiling committee.c: too many arguments to function

