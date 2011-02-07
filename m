Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab1BGQZv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 11:25:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54290 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318Ab1BGQZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 11:25:50 -0500
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
X-Attribution: Tom
Date: Mon, 07 Feb 2011 09:25:33 -0700
In-Reply-To: <AANLkTikhfhYjvmvXtjW-Mszpq8d_3Syo=H4zqWe+1hEg__12255.0142732964$1296923928$gmane$org@mail.gmail.com>
	(Hui Zhu's message of "Sun, 6 Feb 2011 00:37:37 +0800")
Message-ID: <m3hbcfzu9u.fsf@fleche.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> ">" == Hui Zhu <teawater@gmail.com> writes:

>> We have trouble for this printf is GDB is still not accept the patch
>> that make tracepoint support printf, So if you want use it, you need
>> patch the patch in
>> http://sourceware.org/ml/gdb-patches/2011-02/msg00063.html and build
>> your GDB with yourself.

Thanks, I think this example was helpful.

>> Sometimes, GDB will output some value like:
>> inode has been optimized out of existence.
>> res has been optimized out of existence.
>> That is because value of inode and res is optimized. Linux Kernel is
>> built with -O2 so you will get this trouble sometimes. If you do not
>> care about the speed when you debug the Kernel, you can use the patch
>> for Linux Kernel in

I am curious to know what version of GCC you are using.  IME, the VTA
patches really helped with this problem a lot -- though not completely.
If you are not using a VTA-enabled GCC, you should.  And if you are, I
think bug reports about values that are still optimized out would be
useful.

Tom
