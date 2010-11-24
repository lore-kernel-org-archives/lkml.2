Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab0KXOid (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 09:38:33 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40158 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096Ab0KXOib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 09:38:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=nH8dqdQNlSfDILd9tWI+2Bk/AtCPVGH8hf1ujWfUQbonpWKUue1j0VEImPGlC0447K
         F2ucg8cmt337oeFuvw27fvMKuK3FjBPpicH7Ux5shDd8CdDYfzkttrcCAK/qKTxlOEgZ
         2i7TEoa53wQsfqVAK3KYmyTwakbFIOzJe9zEY=
MIME-Version: 1.0
In-Reply-To: <20101124141129.GA15875@ghostprotocols.net>
References: <1290598533-31855-1-git-send-email-tom.leiming@gmail.com>
	<20101124141129.GA15875@ghostprotocols.net>
Date: Wed, 24 Nov 2010 22:38:29 +0800
Message-ID: <AANLkTimQddY=1RpYpfELqY3sS6x30Nneo+4vGcPjb8r7@mail.gmail.com>
Subject: Re: [PATCH 2/2] perf:tools: figure out start address of kernel map
 from /proc/kallsyms
From: Ming Lei <tom.leiming@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, Ian Munsie <imunsie@au1.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Tom Zanussi <tzanussi@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/24 Arnaldo Carvalho de Melo <acme@ghostprotocols.net>:
> Can you please use kallsyms__parse()? Please take a look at
> event__synthesize_kernel_mmap as it also uses it.

Good idea, but kallsyms__parse does not pass a parameter
which indicates if it is a module or kernel symbol to process handler.

So could you agree on adding one parameter which indicates if
the current symbol is module symbol to process handler?

If so, I can use kallsyms__parse.

thanks,
-- 
Lei Ming
