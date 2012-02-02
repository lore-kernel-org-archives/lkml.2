Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843Ab2BBCmi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 21:42:38 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:63657 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546Ab2BBCmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 21:42:37 -0500
X-Authority-Analysis: v=2.0 cv=fNy7LOme c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=B4Y1A9pGR7AA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=O_d6nQBVeB90IoE-GdoA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1328150554.5882.83.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH v4 1/4] trace: Add per_cpu ring buffer control files
From: Steven Rostedt <rostedt@goodmis.org>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 01 Feb 2012 21:42:34 -0500
In-Reply-To: <CAL26m8JSL504zUX+P8WbjOUUjG2WR9idQrh2T8noYrmQYObj4A@mail.gmail.com>
References: <1314062244-2997-1-git-send-email-vnagarnaik@google.com>
	 <1318382410-14967-1-git-send-email-vnagarnaik@google.com>
	 <CAL26m8JSL504zUX+P8WbjOUUjG2WR9idQrh2T8noYrmQYObj4A@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-31 at 15:53 -0800, Vaibhav Nagarnaik wrote:

> 
> Hi Steven,
> 
> I remember you were waiting for a upstream release cycle to complete
> before accepting this patch series. Are you testing it for the next
> release?
> 

I was thinking there was issues before and thought there was going to be
another round of patches or something.

I'll see if I can squeeze out some time to review them again. I'm
currently hunting down some other bugs.

Thanks,

-- Steve


