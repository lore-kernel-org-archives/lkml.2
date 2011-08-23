Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407Ab1HWNYN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 09:24:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:57060 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754898Ab1HWNYJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 09:24:09 -0400
Subject: Re: warning:
 =?UTF-8?Q?=E2=80=98x86=5Fget=5Fevent=5Fconstraints=E2=80=99?= defined but
 not used
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: acme@ghostprotocols.net, mingo@elte.hu, x86@kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 23 Aug 2011 15:23:59 +0200
In-Reply-To: <CAELBVzAXXjfHDkUxSVM39coDC1QyNBtDc-gW27a-yascs2nVuA@mail.gmail.com>
References: <CAELBVzAXXjfHDkUxSVM39coDC1QyNBtDc-gW27a-yascs2nVuA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314105839.8002.51.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-15 at 20:40 -0300, Kevin Winchester wrote:
> Is there are reason why those C
> files are included directly in another C file rather than being linked
> together?  

Sheer suckyness on my part.. we needed a 'quick' fix to make these
CPU_SUP_* things build at all and never got around to cleaning it up
afterwards.

> Or is there some other way the code could be improved and
> also remove the warning at the same time?

creation of a arch/x86/kernel/cpu/perf_event.h and enough code massage
to make all these .c files compile independently would be appreciated,
not sure that'll immediately solve your issue though.

> I do not mind doing some coding here to make this happen.  I am very
> close to a warning-free build, so I would definitely like to take care
> of this one.

You could slip something like it into the 'cleanup' if nothing else
presents itself :-)
