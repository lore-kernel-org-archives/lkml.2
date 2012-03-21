Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391Ab2CUD1L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 23:27:11 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39782 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574Ab2CUD1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 23:27:06 -0400
MIME-Version: 1.0
In-Reply-To: <1332278973.2982.24.camel@pasglop>
References: <1332259260-1943-1-git-send-email-consul.kautuk@gmail.com>
	<1332278936.2982.23.camel@pasglop>
	<1332278973.2982.24.camel@pasglop>
Date: Wed, 21 Mar 2012 08:57:05 +0530
Message-ID: <CAFPAmTQtDnQ-jrc-hqtTshciqnx-iS5wSwCiCN11ZWJUOc-cfg@mail.gmail.com>
Subject: Re: [PATCH 04/20 v3] powerpc/mm/fault.c: Port OOM changes to do_page_fault
From: Kautuk Consul <consul.kautuk@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>, Jimi Xenidis <jimix@pobox.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Christian Dietrich 
	<christian.dietrich@informatik.uni-erlangen.de>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        "Mohd. Faris" <mohdfarisq2010@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>
>> I have done that port already :-) It's in powerpc-next which I will send
>> to Linus to pull today or tomorrow....

Oops, sorry I didn't know that as I don't regularly follow the powerpc tree.
I just did this change for all architectures. :)

>
> BTW. Feel free to review what I've done, it's quite possible that I have
> screwed something up ...

Okay, I'll take a look at it. Thanks again. :)

>
> Cheers,
> Ben.
