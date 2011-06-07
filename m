Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751283Ab1FGGGz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 02:06:55 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:33975 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab1FGGGy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 02:06:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=r8/i2x2vnbXLMSftNETq2rNvax3GcelxCxjMqAnk23QcUjk5Um3/OECBjItxcS2C0y
         3C3vMbIrUIo1/+Jjxf9cCXmZXlW8mz1YXmK1Q7dXkZFsm+oClG9PJ5TOEOTIXNgJMEwV
         0XUCik32E4oiOXeY8azxAXRA9OfQMm2nLqkFY=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1106062106580.22635@chino.kir.corp.google.com>
References: <1307369665.31814.20.camel@gandalf.stny.rr.com>
	<alpine.DEB.2.00.1106062106580.22635@chino.kir.corp.google.com>
Date: Tue, 7 Jun 2011 09:06:53 +0300
X-Google-Sender-Auth: xHtwyvdD8I2VgeA9LIYqjUyMUgo
Message-ID: <BANLkTikmp5CFKykBXaPUP0SBZEto1idDsA@mail.gmail.com>
Subject: Re: [PATCH][GIT PULL] slob/lockdep: Fix gfp flags passed to lockdep
From: Pekka Enberg <penberg@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Matt Mackall <mpm@selenic.com>,
        Paul Mundt <lethal@linux-sh.org>, Nick Piggin <npiggin@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 7, 2011 at 7:09 AM, David Rientjes <rientjes@google.com> wrote:
>> Please pull the latest tip/lockdep/devel tree, which can be found at:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
>> tip/lockdep/devel
>>
>>
>> Steven Rostedt (1):
>>       slob/lockdep: Fix gfp flags passed to lockdep
>
> Shouldn't this be going into Pekka's slab tree?

That's what I'd expect, sure. :-)

However, I'm not pulling from a "tip/lockdep/devel" branch to slab.git
so Steven needs to send this to me in patch format or Ingo picks it up
in which case consider the patch:

Acked-by: Pekka Enberg <penberg@kernel.org>

                          Pekka
