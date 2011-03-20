Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976Ab1CTLJl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 07:09:41 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51059 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab1CTLJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 07:09:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YAvvN1BaG9PDmDzQ/AeaVc/79eOGRrz2tkB0NNtUYKOQnWpWQlAmG2d7w2pyXCs1EK
         Zw9DZdeauK/Dw+BVLP8tXyoxKlAKVNLeFu84L5V5XfqvM2brDFAXdWbtByFdn1GJ0h4z
         BX2LITgUhZ44Dp8ECZzjAAslUn9pYTbmaeM+I=
Date: Sun, 20 Mar 2011 13:09:32 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Julia Lawall <julia@diku.dk>, Pekka Enberg <penberg@kernel.org>,
        =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jonathan Corbet <corbet@lwn.net>,
        LKML <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@shadowen.org>,
        Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nicolas Palix <npalix@diku.dk>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] checkpatch: Test for kmalloc/memset(0) pairs
Message-ID: <20110320110932.GA7001@p183.telecom.by>
References: <1300416744.16880.904.camel@gandalf.stny.rr.com>
 <20110317211548.646b04d2@tpl.lwn.net>
 <1300419170.16880.956.camel@gandalf.stny.rr.com>
 <AANLkTikZK278BR5o1fP_w2u5PUPbgub9QT4XxzSmEhL5@mail.gmail.com>
 <AANLkTi=2d8S_Pi8kuZMXAmNvHa_2KrOs6K+_FF6P7-pU@mail.gmail.com>
 <Pine.LNX.4.64.1103200852080.28495@ask.diku.dk>
 <AANLkTi=MMKvA-9pFiM1K_JSXjS71JLRCem8THnhu-0=N@mail.gmail.com>
 <Pine.LNX.4.64.1103201007430.28495@ask.diku.dk>
 <20110320105412.GA11266@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110320105412.GA11266@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can we tell "0" token from "sizeof(struct {})" in C compiler?

This would solve memset(,0); issue quite nicely.
