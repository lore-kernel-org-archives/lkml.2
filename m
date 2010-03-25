Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab0CYRpk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 13:45:40 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:37186 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab0CYRpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 13:45:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=x9WOBaiM0JfURBZFzTpDUMuGBSht5IcbGQrHB2E96m9U0uJK99qsWQ3NaQ2RY4h6+O
         fd3ZyBzORU6u1ZNX0elL6xzD9pUqM+fNWzAeAE96dcEvqmv7Wxz3JQuYiMlEaCI7ZSrJ
         aG5BX/qacY0qlysccEMxKCFGeATq3fgG/E7CA=
MIME-Version: 1.0
In-Reply-To: <4BABA088.2000405@redhat.com>
References: <1269537767-7553-1-git-send-email-andrea.gelmini@gelma.net>
	 <1269537767-7553-14-git-send-email-andrea.gelmini@gelma.net>
	 <4BABA088.2000405@redhat.com>
Date: Thu, 25 Mar 2010 18:45:36 +0100
X-Google-Sender-Auth: d309ead6e98d01ac
Message-ID: <9cdbb57f1003251045u10a40646of24b7b976a6ec07c@mail.gmail.com>
Subject: Re: [PATCH 14/16] Tools perf probe-finder.c: duplicated include
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-doc@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/3/25 Masami Hiramatsu <mhiramat@redhat.com>:
> Would you mean that <string.h> and "string.h" are duplicated?
> If so, NAK, sorry. Those are different, <string.h> is for
> /usr/include/string.h, and "string.h" is for tools/perf/util/string.h.

I'm an asshole...
Sorry, you're right.

Ciao,
Andrea
