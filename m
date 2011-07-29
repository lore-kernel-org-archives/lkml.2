Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453Ab1G2RxX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 13:53:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:40914 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178Ab1G2RxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 13:53:22 -0400
X-Authority-Analysis: v=1.1 cv=sbbt6Wn8j+VvNVI1Ftt/uHhinWyuFt+R57MN9Ty2Tys= c=1 sm=0 a=S531j9xFrh8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=YQSaZpGtGf7UDQfr9UAA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH v2 1/4] trace-cmd: Add parse error checking target
From: Steven Rostedt <rostedt@goodmis.org>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <CAL26m8Jmy=Rcg6fKghk9Epcj9U6Z2i9UM78hF5_r30U5Qvv9uw@mail.gmail.com>
References: <1310785241-3799-1-git-send-email-vnagarnaik@google.com>
	 <1311619188-4905-1-git-send-email-vnagarnaik@google.com>
	 <1311949173.21143.43.camel@gandalf.stny.rr.com>
	 <CAL26m8Jmy=Rcg6fKghk9Epcj9U6Z2i9UM78hF5_r30U5Qvv9uw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 29 Jul 2011 13:53:20 -0400
Message-ID: <1311962000.21143.69.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-29 at 10:41 -0700, Vaibhav Nagarnaik wrote:

> Thanks Steve. I will send the man page patch.

BTW, I played with this and I have a few issues. I'll still accept the
patch as it's not that big of a deal. But here's some improvements that
can be made.


It should load in the plugins. As the plugins can process failed events
well. If you don't want the plugins than you can just do what we do with
report, add a -N to prevent plugins from being loaded.

It should also read a trace.dat file if one is provided on the command
line. If you don't add a file then it will use the local events of the
system, if possible.

This would make it even more useful.

Thanks!

-- Steve


