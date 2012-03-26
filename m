Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933011Ab2CZQz6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 12:55:58 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37229 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932550Ab2CZQz4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 12:55:56 -0400
MIME-Version: 1.0
In-Reply-To: <1332779529.6160.96.camel@joe2Laptop>
References: <1332775946-2162-1-git-send-email-consul.kautuk@gmail.com>
	<1332778595.6160.84.camel@joe2Laptop>
	<CAFPAmTSyYJkATAD32WqHZY_PdWGjitEq4vgqCZeqjo+V24dh3Q@mail.gmail.com>
	<1332779529.6160.96.camel@joe2Laptop>
Date: Mon, 26 Mar 2012 12:55:56 -0400
Message-ID: <CAFPAmTTAf660w7Xcidzi5KHrJoDSEiWJdOMhyUesGxih8bs1wA@mail.gmail.com>
Subject: Re: [PATCH 19/20 v3] sparc/mm/fault_32.c: Port OOM changes to do_sparc_fault
From: Kautuk Consul <consul.kautuk@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: davem@davemloft.net, Paul Gortmaker <paul.gortmaker@windriver.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>
>> you must be having the same problem in viewing the patch file
>> as me due to the email client itself inserting invalid spaces here and there.
>
> Nope.  That's not it.
>
>> by the way, what tab-spaces are you using when you open it in vim ?
>
> I use vim as an editor as infrequently as possible.
>
> Your original patch used 6 tabs and 2 spaces.
> Tab size in kernel style is always 8.
>
> Again, make sure your tab indentation is set to 8.
>

I see what you are saying.
One question: Is it possible to include this kinda checking
(multiline statements with paranthesis checking assuming tab
indentation 8) in the
checkpatch.pl script ?
It would be easier to not make such mistakes in future with that kind of tool.
