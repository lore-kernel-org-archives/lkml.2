Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014Ab2F0WOs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 18:14:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17370 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418Ab2F0WOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 18:14:47 -0400
X-Authority-Analysis: v=2.0 cv=StQSGYy0 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=h-wduvCxVmkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=pGLkceISAAAA:8 a=11PO3pVRYGfuwif_jKoA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1340835285.16702.53.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] traceevent: make clean fix
From: Steven Rostedt <rostedt@goodmis.org>
To: Konstantin Stepanyuk <konstantin.stepanyuk@gmail.com>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>
Date: Wed, 27 Jun 2012 18:14:45 -0400
In-Reply-To: <1340833934-18783-1-git-send-email-konstantin.stepanyuk@gmail.com>
References: <1340833934-18783-1-git-send-email-konstantin.stepanyuk@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Except, that the subject line needs to be a little better. Perhaps:

tools lib traceevent: Fix clean target in Makefile

As "make clean fix" sounds like we are making a clean fix. Which I hope
all fixes would be ;-)

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


On Wed, 2012-06-27 at 15:52 -0600, Konstantin Stepanyuk wrote:
> Dependency files were not cleaned up. Add missing space to fix the
> issue.
> 
> Signed-off-by: Konstantin Stepanyuk <konstantin.stepanyuk@gmail.com>
> ---
>  tools/lib/traceevent/Makefile |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
> index 3d69aa9..423f4b8 100644
> --- a/tools/lib/traceevent/Makefile
> +++ b/tools/lib/traceevent/Makefile
> @@ -290,7 +290,7 @@ install_lib: all_cmd install_plugins install_python
>  install: install_lib
>  
>  clean:
> -	$(RM) *.o *~ $(TARGETS) *.a *.so $(VERSION_FILES).*.d
> +	$(RM) *.o *~ $(TARGETS) *.a *.so $(VERSION_FILES) .*.d
>  	$(RM) tags TAGS
>  
>  endif # skip-makefile


