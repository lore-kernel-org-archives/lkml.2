Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840Ab1CTOsi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 10:48:38 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34328 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab1CTOsg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 10:48:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=DgDiFszJO2Gt3NZTg//spifpFn7cJG2HDiVAchCD9LhFtJ2orhlTsr0IatvHSked6I
         qoFPzNJMESI907ebpCgomhHvPp2W+zqmuqAtk+YrdpiNf4PbgZsXzHHqegOZtP+RhLY+
         Q9QWeQ8W5Cyv72TG5VkIaJ8S7FGlza/CofXJA=
Date: Sun, 20 Mar 2011 15:48:27 +0100
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Julia Lawall <julia@diku.dk>, Pekka Enberg <penberg@kernel.org>,
        =?UTF-8?B?QW3DqXJpY28=?= Wang <xiyou.wangcong@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jonathan Corbet <corbet@lwn.net>,
        LKML <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@shadowen.org>,
        Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nicolas Palix <npalix@diku.dk>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] checkpatch: Test for kmalloc/memset(0) pairs
Message-ID: <20110320154827.7ba3358b@varda>
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
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Sun, 20 Mar 2011 11:54:12 +0100
Ingo Molnar <mingo@elte.hu> escribió:


> 
> I think the point Pekka tried to make is to have it integrated into the kbuild 
> mechanism as well at a certain point. That way it's very easy to use it and we 
> maintainers could require frequent patch submitters to use those tools to check 
> the quality of their patches. Right now i cannot require that, as it's not part 
> of the kernel repo. Requiring a checkpatch.pl check is much easier, as it's 
> available to everyone who is writing kernel patches.

 But a perl interpreter is not shipped with the kernel, is it? neither a
 posix shell or a python interpreter ...
 The scripts are already shipped with the kernel, the "interpreter" have
 to be installed in the dev machine like you have to install perl, make,
 gcc, etc
 
 just my two cents as a bystander :)

> 
> Thanks,
> 
> 	Ingo
> --
