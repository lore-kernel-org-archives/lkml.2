Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab1GNNJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 09:09:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63208 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564Ab1GNNJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 09:09:39 -0400
X-Authority-Analysis: v=1.1 cv=yMxAJ7W7nAoPh8ZdbvCArpG6pAdHwgpzIvOq8QbMesM= c=1 sm=0 a=l8LWmUGdTDcA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=OAouQKHyo7iVPam7dNoA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC 0/4] streamline_config clean-ups
From: Steven Rostedt <rostedt@goodmis.org>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Steven Rostedt <srostedt@redhat.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>
In-Reply-To: <CACqU3MX4=AQyH4TXi+LaHV6WWRsLZpGf7c=iwQHm6Mqsr6SgYA@mail.gmail.com>
References: <1309563076-5050-1-git-send-email-lacombar@gmail.com>
	 <CACqU3MUrCODMx=8Bu+YDxy2BJwjm-77PXFob5OwHn=fr5mTdkg@mail.gmail.com>
	 <1310170759.2780.37.camel@fedora>
	 <1310604899.27864.4.camel@gandalf.stny.rr.com>
	 <CACqU3MX4=AQyH4TXi+LaHV6WWRsLZpGf7c=iwQHm6Mqsr6SgYA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 14 Jul 2011 09:09:37 -0400
Message-ID: <1310648977.27864.22.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-13 at 22:41 -0400, Arnaud Lacombe wrote:

> yes... it could not have. I missed a $(srctree), an export, and an
> error check. Attached patch should fix it, behavior (see below) with
> this patch is consistent between v3.0-rc6 and the tip of the patched
> branch.

That seems to work. Could you resend a fixed patchset?

> 
> Btw, as of v3.0-rc6, localmodconfig does not produce a valid .config.
> Local kernel is a Fedora 14 kernel, based on
> config-2.6.35.13-91.fc14.x86_64. The perl script complete fine, but
> the config is then restarted, I'm not sure if it is the intended
> behavior.

Hmm, not sure exactly what you mean. The script should run
(silent)oldconfig after it does the localmodconfig to fill in the stuff
that it caused to change. Did you notice something that broke?

-- Steve


