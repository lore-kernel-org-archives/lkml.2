Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120Ab2DWS74 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 14:59:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7698 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086Ab2DWS7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 14:59:54 -0400
X-Authority-Analysis: v=2.0 cv=XbcLPfF5 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=YF16_Tu_DXMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=VwQbUJbxAAAA:8 a=57SyGIRnAAAA:8 a=9r_VzUzzPz3e4abK9bsA:9 a=PUjeQqilurYA:10 a=U62fhAwekXMA:10 a=TIV7c6GJmisA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1335207592.28106.118.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 11/11] parse-filter: Check return value of arg_to_str()
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 23 Apr 2012 14:59:52 -0400
In-Reply-To: <1335157118-14658-12-git-send-email-namhyung.kim@lge.com>
References: <1335157118-14658-1-git-send-email-namhyung.kim@lge.com>
	 <1335157118-14658-12-git-send-email-namhyung.kim@lge.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-23 at 13:58 +0900, Namhyung Kim wrote:
> The arg_to_str() can fail so we should handle that case properly.

Applied thanks!

I also applied your first series. I'll be pushing this to kernel.org
shortly.

-- Steve

> 
> Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
> ---
>  parse-filter.c |   15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 


