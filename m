Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757646Ab1BKQ36 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 11:29:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37626 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757234Ab1BKQ34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 11:29:56 -0500
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
	<m3y65qv7m8.fsf@fleche.redhat.com>
	<AANLkTi=UrBZUttP9Q=2DrNXs8MAw4FXWhv6f_Pz8ad8o@mail.gmail.com>
X-Attribution: Tom
Date: Fri, 11 Feb 2011 09:29:24 -0700
In-Reply-To: <AANLkTi=UrBZUttP9Q=2DrNXs8MAw4FXWhv6f_Pz8ad8o@mail.gmail.com>
	(Hui Zhu's message of "Wed, 9 Feb 2011 21:25:50 +0800")
Message-ID: <m3mxm2mt5n.fsf@fleche.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> ">" == Hui Zhu <teawater@gmail.com> writes:

>> Handle the var is enough for KGTP.  Could you send me a introduce
>> link for VTA?  I will post the the VTA to the HOWTO of the kgtp.

Here's the original plan:
http://gcc.gnu.org/wiki/Var_Tracking_Assignments

Alexandre also wrote a paper about it for the GCC Summit.  You can
probably dig that up without much effort.  There's also a follow-up
effort, the paper there is called "Consistent Views at Recommended
Breakpoints".  This one hasn't been implemented yet, though.

Tom
