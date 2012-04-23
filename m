Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab2DWSrc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 14:47:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11059 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab2DWSrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 14:47:31 -0400
X-Authority-Analysis: v=2.0 cv=XbcLPfF5 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=WomB85Q-PKsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=57SyGIRnAAAA:8 a=qnMPPnmNQjRLvb204ZkA:9 a=PUjeQqilurYA:10 a=TIV7c6GJmisA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1335206848.28106.115.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 08/11] parse-events: Fix some comments
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 23 Apr 2012 14:47:28 -0400
In-Reply-To: <1335157118-14658-9-git-send-email-namhyung.kim@lge.com>
References: <1335157118-14658-1-git-send-email-namhyung.kim@lge.com>
	 <1335157118-14658-9-git-send-email-namhyung.kim@lge.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-23 at 13:58 +0900, Namhyung Kim wrote:
> Update and add missing argument descriptions and fix some typo
> on function comments.
> 

Applied, thanks!

> Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
> ---

>   *
> - * Returns: 0 on success, -1 field not fould, or 1 if buffer is full.
> + * Returns: 0 on success, -1 field not found, or 1 if buffer is full.

Must have been some dvorak/qwerty brain fart (I use dvorak). As, the
qwerty 'l' is the dvorak 'n'.

-- Steve

>   */
>  int pevent_print_num_field(struct trace_seq *s, const char *fmt,
>  			   struct event_format *event, const char *name,


