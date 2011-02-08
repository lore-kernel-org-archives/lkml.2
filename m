Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab1BHQBJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 11:01:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46547 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752646Ab1BHQBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 11:01:08 -0500
From: Tom Tromey <tromey@redhat.com>
To: Hui Zhu <teawater@gmail.com>
Cc: linux-kernel@vger.kernel.org, Michael Snyder <msnyder@vmware.com>,
        Marc Khouzam <marc.khouzam@ericsson.com>,
        Thiago Jung Bauermann <thiago.bauermann@gmail.com>,
        Steven <mqyoung@gmail.com>, colyli@gmail.com,
        Christoph Hellwig <hch@infradead.org>,
        "gdb\@sourceware.org" <gdb@sourceware.org>
Subject: Re: [PATCH] Linux Kernel GDB tracepoint module 2011-02-05
References: <AANLkTikhfhYjvmvXtjW-Mszpq8d_3Syo=H4zqWe+1hEg__12255.0142732964$1296923928$gmane$org@mail.gmail.com>
	<m3hbcfzu9u.fsf@fleche.redhat.com>
	<AANLkTinMx8mJYiDps3TuuaA1B4NLHi-PuCKm2=sTqyR0@mail.gmail.com>
X-Attribution: Tom
Date: Tue, 08 Feb 2011 09:00:47 -0700
In-Reply-To: <AANLkTinMx8mJYiDps3TuuaA1B4NLHi-PuCKm2=sTqyR0@mail.gmail.com>
	(Hui Zhu's message of "Tue, 8 Feb 2011 21:23:52 +0800")
Message-ID: <m3y65qv7m8.fsf@fleche.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> ">" == Hui Zhu <teawater@gmail.com> writes:

>> My gcc is 4.4.5.  Does it have VTA?

Nope.  VTA went in for 4.5.

>> Use the patch is easier than update gcc sometimes, right?  :)

Yeah.

>> BTW does VTA can handle the issue that after -O2 a lot of code
>> execution order is worong?
>> It affect me when I debug the Linux Kernel in qemu.

My understanding is that VTA is solely about better tracking of values
through optimization passes.  It doesn't affect code reordering, by
design.

Tom
