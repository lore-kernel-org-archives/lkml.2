Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951Ab1CTLGb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 07:06:31 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:61942 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab1CTLG2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 07:06:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ETdTqn1O2C9FXnD0obwfg/P+jke5P2E6ux7cuObt5+g5mcdNADSql06g+w17KLPA2e
         hba4idHHEfD0TA8XtjWnDmejmtBEGk/VaRpb2FKFyhpDlb9BLH9fUxppniqKRYSj7KR1
         8qKSMbI5AD2pikdHysfaOSqV7trCZ5EWZMexY=
MIME-Version: 1.0
In-Reply-To: <20110320105412.GA11266@elte.hu>
References: <1300416744.16880.904.camel@gandalf.stny.rr.com>
	<20110317211548.646b04d2@tpl.lwn.net>
	<1300419170.16880.956.camel@gandalf.stny.rr.com>
	<AANLkTikZK278BR5o1fP_w2u5PUPbgub9QT4XxzSmEhL5@mail.gmail.com>
	<AANLkTi=2d8S_Pi8kuZMXAmNvHa_2KrOs6K+_FF6P7-pU@mail.gmail.com>
	<Pine.LNX.4.64.1103200852080.28495@ask.diku.dk>
	<AANLkTi=MMKvA-9pFiM1K_JSXjS71JLRCem8THnhu-0=N@mail.gmail.com>
	<Pine.LNX.4.64.1103201007430.28495@ask.diku.dk>
	<20110320105412.GA11266@elte.hu>
Date: Sun, 20 Mar 2011 13:06:26 +0200
X-Google-Sender-Auth: QShnKPUcXz9DmzK9So9IGlwIbMg
Message-ID: <AANLkTimdbs2AZ9OE6j+=ziJA1LR2wkZR5qsT8AEq--5x@mail.gmail.com>
Subject: Re: [PATCH] checkpatch: Test for kmalloc/memset(0) pairs
From: Pekka Enberg <penberg@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Julia Lawall <julia@diku.dk>,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jonathan Corbet <corbet@lwn.net>,
        LKML <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@shadowen.org>,
        Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nicolas Palix <npalix@diku.dk>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Mar 20, 2011 at 12:54 PM, Ingo Molnar <mingo@elte.hu> wrote:
>> Indeed that one seems to be quite out of date.  You can get the most
>> recent version here: https://launchpad.net/~npalix/+archive/coccinelle
>
> With tools/coccinelle/ you would never run into such problems of distributing
> the latest stable version to your fellow kernel developers: it would always be
> available in tools/coccinelle/.
>
> Integration, synergy, availability, distribution and half a dozen other
> buzzwords come to mind as to why it's a good idea to have kernel-focused
> tools hosted in the kernel repo :-)
>
> IMO it's an option to consider.

That's my thinking too. Yes, 80 KLOC of OCaml in the kernel tree
sounds crazy but I think the practical advantages might be enough to
justify it. Btw, would git-submodule be something to consider here?
