Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab2BUBSk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 20:18:40 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20737 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084Ab2BUBSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 20:18:39 -0500
X-Authority-Analysis: v=2.0 cv=Vp2h8pKn c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=axnUGrQYtO0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=M9ckvtkEzx909E5hjAoA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1329787118.25686.52.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] Re: [PATCH] trace: don't print an extra separator of
 flags
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Mon, 20 Feb 2012 20:18:38 -0500
In-Reply-To: <1329770610-703006-1-git-send-email-avagin@openvz.org>
References: <1329767276.25686.40.camel@gandalf.stny.rr.com>
	 <1329770610-703006-1-git-send-email-avagin@openvz.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-20 at 23:43 +0300, Andrew Vagin wrote:
> > Could you send me that patch. Or a change to the kernel that shows the
> > problemi.
> 
> Without my patch:
>     event-sample-1731  [000] ...1 546886.253576: foo_bar: foo hello 3 |A B
>     event-sample-1731  [000] ...1 546887.253677: foo_bar: foo hello 4 |A B
> 
> With my patch:
>     event-sample-1731  [000] ...1 546886.253576: foo_bar: foo hello 3 A B
>     event-sample-1731  [000] ...1 546887.253677: foo_bar: foo hello 4 A B

Ah, nevermind. This bug actually does show up in another tracepoint
somewhere (I  don't remember which). But I've been meaning to fix it.

Thanks! I'll take your patch. But since it is such a minor bug. I'll put
it into the v3.4 queue.

-- Steve


