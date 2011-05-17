Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182Ab1EQTlK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 15:41:10 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55393 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087Ab1EQTlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 15:41:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=RlS/SXRkXKkQ+yjvg/ive4JkyymwmvDrcwAk5NixbTPULqtsvVRj68+Rpdjxiv/FMm
         1mByeevcug84xkEJUYavwCtcOEirQiZx4apJw05+H2FvLl6+doMIzpwAE2Mluic+SZqs
         a7q9s2m+gPtDDYcirOIdVRS40EGoqmZY3KUi0=
MIME-Version: 1.0
In-Reply-To: <4DD2CA02.9040707@googlemail.com>
References: <BANLkTi=2jW5PHB6QCaddHeZH0P=9PKWosw@mail.gmail.com>
	<1305577420-3685-1-git-send-email-abogani@kernel.org>
	<878vu6nftw.fsf@rustcorp.com.au>
	<4DD2CA02.9040707@googlemail.com>
Date: Tue, 17 May 2011 21:41:06 +0200
X-Google-Sender-Auth: gG31pWncg5C7bsWLJRRuLfuM8Ok
Message-ID: <BANLkTinPG100vbVAN1RZWb3h9Xuu6SKJ0Q@mail.gmail.com>
Subject: Re: [PATCH] module: Use binary search in lookup_symbol()
From: Alessio Igor Bogani <abogani@kernel.org>
To: Dirk Behme <dirk.behme@googlemail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Anders Kaseorg <andersk@ksplice.com>, Tim Abbott <tabbott@ksplice.com>,
        Tim Bird <tim.bird@am.sony.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Jason Wessel <jason.wessel@windriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Mr. Behme,

2011/5/17 Dirk Behme <dirk.behme@googlemail.com>:
[...]
> With the version above we should get a warning
>
> kernel/module.c: In function 'lookup_symbol':
> kernel/module.c:1809: warning: unused variable 'ks'

Sorry It's my fault. I'll provide a right version in few hours.

Ciao,
Alessio
