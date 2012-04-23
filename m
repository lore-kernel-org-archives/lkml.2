Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab2DWSfn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 14:35:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32357 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217Ab2DWSfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 14:35:42 -0400
X-Authority-Analysis: v=2.0 cv=MNHiabll c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=F3zZtCsI51kA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=iHZuNCMvQNIeiZ13AXAA:9 a=eGJ6N3x9wTzuXkCdx6gA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1335206140.28106.110.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 04/11] parse-events: Remove unused arg->dynarray.index
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 23 Apr 2012 14:35:40 -0400
In-Reply-To: <1335157118-14658-5-git-send-email-namhyung.kim@lge.com>
References: <1335157118-14658-1-git-send-email-namhyung.kim@lge.com>
	 <1335157118-14658-5-git-send-email-namhyung.kim@lge.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-23 at 13:58 +0900, Namhyung Kim wrote:
> It seems index field of struct print_arg_dynarray is not used.
> Let's remove it.

Actually, the "non-use" looks like a bug. Where it is set to 0 (it
should be set to NULL), an 'arg' is allocated, but it looks to be what
index wants.

The array, may be allocated with a set size, and we may use this info
later.

Looks to be unfinished code, that I started but never got to finish.

-- Steve


