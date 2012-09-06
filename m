Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760089Ab2IFAmg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 20:42:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12682 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275Ab2IFAmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 20:42:35 -0400
X-Authority-Analysis: v=2.0 cv=Hsb06jvS c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Dqp4FYZIpSQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=udbR1u0CsFIA:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=1v4Z2PpR2RWiSWPz0iAA:9 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=LI9Vle30uBYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1346892154.27919.83.camel@gandalf.local.home>
Subject: Re: [PATCH] perf: clean should remove libtraceevent.a too
From: Steven Rostedt <rostedt@goodmis.org>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Namhyung Kim <namhyung@kernel.org>
Date: Wed, 05 Sep 2012 20:42:34 -0400
In-Reply-To: <1346890240-61205-1-git-send-email-dsahern@gmail.com>
References: <1346890240-61205-1-git-send-email-dsahern@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-05 at 18:10 -0600, David Ahern wrote:
> It's built as part of perf, so it should be cleaned too.
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/Makefile |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 90d8e09..5f0259e 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -1068,6 +1068,7 @@ clean:
>  	$(RM) $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)PERF-CFLAGS
>  	$(RM) $(OUTPUT)util/*-bison*
>  	$(RM) $(OUTPUT)util/*-flex*
> +	$(RM) $(LIBTRACEEVENT)
>  	$(python-clean)

Actually, this should do the clean in the tools/lib/traceevent
directory, as this change wont clean the objects created.

-- Steve


