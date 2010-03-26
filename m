Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab0CZN15 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 09:27:57 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:61075 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709Ab0CZN1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 09:27:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=L5pOIPTF7wvK3xGfDSM0x4cnIkBGBZ9WdKzzcFJfmCFSK0vs4VhN8+xOZekK2p3ymB
         AiaksIMU4bglP7Pg0k8GWyxFYElIQs+UDzQQn9C/3PvuOWQxYnbnqHoMkgfKRo9+srJ+
         C8xwOUFlu9akVHfbt27+PNJBQWzq/Z2GMn6K8=
MIME-Version: 1.0
In-Reply-To: <20100326080048.GB27394@elte.hu>
References: <1269537767-7553-1-git-send-email-andrea.gelmini@gelma.net>
	 <1269537767-7553-13-git-send-email-andrea.gelmini@gelma.net>
	 <20100326080048.GB27394@elte.hu>
Date: Fri, 26 Mar 2010 14:27:53 +0100
X-Google-Sender-Auth: 91ca5850e5fe8519
Message-ID: <9cdbb57f1003260627i487c564bv351e78d23991c960@mail.gmail.com>
Subject: Re: [PATCH 13/16] Tools perf builtin-trace.c: duplicated includes
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-doc@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/3/26 Ingo Molnar <mingo@elte.hu>:
> Please send a more complete patch that fixes the root cause of the
> duplication: a few header files are in the middle of the .c file - all
> inclusions should be at the top of the file.

I try to be less intrusive as possibile.
Now I reworked the patch, and I'll send it in a while.

Thanks a lot for your advices,
Andrea
