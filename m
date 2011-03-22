Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab1CVIVV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 04:21:21 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53441 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884Ab1CVIVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 04:21:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=G0fjye9/7xIsHiJUZ4cd2hyNL4TpLqlA4kVsIuqdehRznWUwA4QaaSIzggve7gZqgb
         ujw3TXca/k2tBzrtZ5rqq5FdEA4Tn8sTZtUqsbRvm7EFp24kk/WKLLgnw9Bs5CA9QqDQ
         P9X1D1XowaB0kVA7hVfiZRI1fC27Uod6LsI8I=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1103212105490.15815@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1103212105490.15815@swampdragon.chaosbits.net>
Date: Tue, 22 Mar 2011 10:21:18 +0200
X-Google-Sender-Auth: Skc4wicfLBa3mVEJzvW-SUUyF_c
Message-ID: <AANLkTinmAJsXy=iJ5Fq-+CLTAGXTtLGhULRUf=Q1rkY1@mail.gmail.com>
Subject: Re: PATCH][RFC][resend] CC_OPTIMIZE_FOR_SIZE should default to N
From: Pekka Enberg <penberg@kernel.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Daniel Lezcano <daniel.lezcano@free.fr>,
        Eric Paris <eparis@redhat.com>, Roman Zippel <zippel@linux-m68k.org>,
        linux-kbuild@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesper,

On Mon, Mar 21, 2011 at 10:08 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> I believe that the majority of systems we are built on want a -O2 compiled
> kernel. Optimizing for size (-Os) is mainly benneficial for embedded
> systems and systems with very small CPU caches (correct me if I'm wrong).

Please take a look at commit 0910b44 ("Expose "Optimize for size"
option for everybody") for the reasoning behind defaulting to -Os.

                        Pekka
