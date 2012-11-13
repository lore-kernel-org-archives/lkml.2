Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab2KMMv2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 07:51:28 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:41648 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481Ab2KMMv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 07:51:26 -0500
MIME-Version: 1.0
In-Reply-To: <14097.1352805150@warthog.procyon.org.uk>
References: <CA+5PVA5vMyNmQYCLX315Jc+kN9zQuZo_h0Devpjfr43TezE-qA@mail.gmail.com>
	<1378.1352379110@warthog.procyon.org.uk>
	<14071.1352805065@warthog.procyon.org.uk>
	<14097.1352805150@warthog.procyon.org.uk>
Date: Tue, 13 Nov 2012 07:51:25 -0500
Message-ID: <CA+5PVA4jHJeE6nZeZyqHnE9QtMvUGW-xGeKrizwATm96QTxeXQ@mail.gmail.com>
Subject: Re: [GIT PULL] UAPI: perf fixes
From: Josh Boyer <jwboyer@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: acme@ghostprotocols.net, mingo@kernel.org, tglx@linutronix.de,
        bp@alien8.de, namhyung@gmail.com, torvalds@linux-foundation.org,
        paulus@samba.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 6:12 AM, David Howells <dhowells@redhat.com> wrote:
> David Howells <dhowells@redhat.com> wrote:
>
>> Josh Boyer <jwboyer@gmail.com> wrote:
>>
>> > This patch seems to break building perf on ppc64.  It fails with:
>>
>> Hmmm...  Getting my hands on an ARM or ppc/ppc64 box running Fedora is a
>> problem, and as far as I know, this needs to be built natively or maybe
>> cross-compiled with a full environment (including graphics libs).
>
> Actually, having said that, it doesn't need to run Fedora specifically - only
> a sufficiently recent environment that it can build a cutting-edge kernel.

You can just use koji scratch builds if you want to test Fedora kernels
Either arm-koji or ppc-koji should work.  If you want actual access to a
machine, I'm sure we can find one.

The error that is hitting ARM and ppc before your patch seemed to also
be hit with sparc and was fixed by David Miller with commit 776260818
by just pointing to "../../arch/sparc/include/uapi/asm/unistd.h".  That
might be a temporary solution.

josh
