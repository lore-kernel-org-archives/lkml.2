Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627Ab0KPU5c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 15:57:32 -0500
Received: from smtp-out.google.com ([216.239.44.51]:48456 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755992Ab0KPU5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 15:57:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=j2dXbbfAxQSUDE3vHV7Wj5RL7wAtdIG0YZQ8/y2XXVAnnBBQYlxSSvKjjR3ra2sIf1
         +JxCL4Kz3ecy5r75PxJg==
Date: Tue, 16 Nov 2010 12:57:21 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Florian Mickler <florian@mickler.org>, Valdis.Kletnieks@vt.edu,
        Jesper Juhl <jj@chaosbits.net>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ying Han <yinghan@google.com>,
        Bodo Eggert <7eggert@web.de>, Mandeep Singh Baines <msb@google.com>,
        "Figo.zhang" <figo1802@gmail.com>
Subject: Re: [PATCH] Revert oom rewrite series
In-Reply-To: <20101116145551.49c47df5@lxorguk.ukuu.org.uk>
Message-ID: <alpine.DEB.2.00.1011161255430.1193@chino.kir.corp.google.com>
References: <20101115093410.BEFD.A69D9226@jp.fujitsu.com> <20101114181905.bc5b44f9.akpm@linux-foundation.org> <20101115113238.BF06.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1011150215460.2986@chino.kir.corp.google.com> <alpine.LNX.2.00.1011160027180.22346@swampdragon.chaosbits.net>
 <34565.1289866395@localhost> <20101116110310.1502de2a@lxorguk.ukuu.org.uk> <20101116140341.42561c84@schatten.dmk.lab> <20101116145551.49c47df5@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Nov 2010, Alan Cox wrote:

> Yes - so why is it spewing crap, annoying users and trying to irritate
> application authors. It's not 2012 yet.
> 

It's a WARN_ON_ONCE() so it will only spew a single line as a reminder 
that the application needs to be updated; would you prefer that to be 
suppressed until a year before removal, for example?
