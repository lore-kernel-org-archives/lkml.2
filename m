Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953Ab2EUOOs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 10:14:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6293 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756559Ab2EUOOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 10:14:47 -0400
X-Authority-Analysis: v=2.0 cv=cssZYiEi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=zRYvwIHoE_gA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=1XWaLZrsAAAA:8 a=D0_6n5RGYKENDmzGOu8A:9 a=747XSJ5_Fo4ZC2Q57bwA:7 a=PUjeQqilurYA:10 a=UTB_XpHje0EA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337609685.5576.1.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 1/2] Revert "trace-cmd: Add function declaration to fix
 compile warning"
From: Steven Rostedt <rostedt@goodmis.org>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Justin Teravest <teravest@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 21 May 2012 10:14:45 -0400
In-Reply-To: <1332188923-13375-1-git-send-email-vnagarnaik@google.com>
References: <1332188923-13375-1-git-send-email-vnagarnaik@google.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-19 at 13:28 -0700, Vaibhav Nagarnaik wrote:
> This reverts commit 1fc4fb039bfa3f0358d7e9810de71c58a7b32b64.
> 
> Steven added commit ba911ea7fc1fdd13e3bce1b2001f5b432df8edae which does
> exactly the same thing. Now we end up with a duplicate declaration of
> the function trace_util_ftrace_options(). Reverting the commit gets rid
> of the warning.

Cleaning out my INBOX again, and came across these two patches. I
applied them now.

My INBOX gets blasted sometimes, and I miss patches like this. Don't be
afraid to ping me after a week if I don't apply them.

Or if you don't mind waiting a few months, where I start cleaning out my
INBOX, I'll apply them when I come across them again ;-)

-- Steve

> 
> Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
> ---
>  trace-cmd.h |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/trace-cmd.h b/trace-cmd.h
> index 3f522ee..f904dc5 100644
> --- a/trace-cmd.h
> +++ b/trace-cmd.h
> @@ -218,7 +218,6 @@ long tracecmd_flush_recording(struct tracecmd_recorder *recorder);
>  /* --- Plugin handling --- */
>  extern struct plugin_option trace_ftrace_options[];
>  
> -void trace_util_ftrace_options(void);
>  void trace_util_add_option(const char *name, const char *val);
>  void trace_util_load_plugins(struct pevent *pevent, const char *suffix,
>  			     void (*load_plugin)(struct pevent *pevent,


