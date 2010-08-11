Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299Ab0HKUjw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 16:39:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39729 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755823Ab0HKUjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 16:39:51 -0400
X-Authority-Analysis: v=1.1 cv=nbWoJD01ruQLYOYE44JZbYtzz81AmFDL3LnuPvZDHs8= c=1 sm=0 a=-XaH9CfXjdEA:10 a=Q9fys5e9bTEA:10 a=IXo+6rlC6z1XzBFn1RNpIA==:17 a=GTiQKF9qWBHQXCNfUMkA:9 a=ErxMfPoovXvU6JGkIWn19h1O8q8A:4 a=PUjeQqilurYA:10 a=IXo+6rlC6z1XzBFn1RNpIA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.87.39
Subject: Re: [Uclinux-dist-devel] [PATCH] tracing: extend recordmcount to 
 better support Blackfin mcount
From: Steven Rostedt <rostedt@goodmis.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Mike Frysinger <vapier@gentoo.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org
In-Reply-To: <AANLkTikCyULM3Mc25hJJn_cD=vWnWwgbi5qxoHDHA2kn@mail.gmail.com>
References: <1281079584-21205-1-git-send-email-vapier@gentoo.org>
	 <1281552896.3058.41.camel@gandalf.stny.rr.com>
	 <AANLkTikCyULM3Mc25hJJn_cD=vWnWwgbi5qxoHDHA2kn@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 11 Aug 2010 16:39:49 -0400
Message-ID: <1281559189.3058.42.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-11 at 15:18 -0400, Mike Frysinger wrote:
> On Wed, Aug 11, 2010 at 14:54, Steven Rostedt wrote:
> > You want me to pull it? or should this go via another tree?
> 
> i was planning on it going through your tree ;)
> -mike

Sure, it looks harmless. I'll pull it in and test it and if it doesn't
hurt anything on x86, I'll push it out for 2.6.36.

-- Steve


