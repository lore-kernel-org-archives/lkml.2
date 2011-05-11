Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142Ab1EKSLl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 14:11:41 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43425 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab1EKSLk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 14:11:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=B81fs+BCKACPsxrEJWwhbnp0m99nGoq20rr/XGBe82ffc9ohgnNplVhcP2TMUjFd71
         r1ADqY25v0brV3oqgEVIXrtCmPW3TVPxJt61PsSOwoZTJsnXV/o2e7Mj5W4Q4HR7RBY1
         P38Pb1e2Xtv5WzdHDxJxWIZqPkWmWzCSAT8io=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=y60Jt3-OMzbxQJzGkvzCzNJfJtA@mail.gmail.com>
References: <1302960373-5309-1-git-send-email-abogani@kernel.org>
	<BANLkTi=y60Jt3-OMzbxQJzGkvzCzNJfJtA@mail.gmail.com>
Date: Wed, 11 May 2011 09:04:20 +0200
X-Google-Sender-Auth: KrbM_-A08nayBM4ysLxaAyWlrPo
Message-ID: <BANLkTimfFEv+vZ8dYvhG0oj2Q4g+KnG4aA@mail.gmail.com>
Subject: Re: [PATCH 0/4] Speed up the symbols' resolution process V4
From: Alessio Igor Bogani <abogani@kernel.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Tim Abbott <tabbott@ksplice.com>,
        Anders Kaseorg <andersk@ksplice.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Tim Bird <tim.bird@am.sony.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Mr. Frysinger,

2011/5/11 Mike Frysinger <vapier.adi@gmail.com>:
> this breaks symbol prefixed arches (like Blackfin):
>  CC      kernel/softirq.o
> /tmp/ccp3A6LU.s: Assembler messages:
> /tmp/ccp3A6LU.s:3734: Error: symbol `___ksymtab__local_bh_enable' is
> already defined
> make[1]: *** [kernel/softirq.o] Error 1

Could you provide the preprocessed file and details about the toolchain used?

Thanks!

Ciao,
Alessio
