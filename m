Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933214Ab2CZR4l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 13:56:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54487 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932913Ab2CZR4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 13:56:40 -0400
Message-ID: <4F70ADB7.802@zytor.com>
Date: Mon, 26 Mar 2012 10:56:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Jan Beulich <JBeulich@suse.com>
Subject: Re: [GIT PULL] x86, microcode fixes for 3.2
References: <20111128204311.GA2814@aftab> <20111202194658.GF15204@aftab> <20111205092612.GB29641@elte.hu> <20111205151016.GC7834@aftab> <4F6F719B.5020806@zytor.com> <20120326084810.GA31480@aftab> <4F7082BD.9030107@zytor.com> <20120326152553.GI32090@aftab>
In-Reply-To: <20120326152553.GI32090@aftab>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a version of the automatic hash generator written in Perl:

http://www.zytor.com/~hpa/phash/

There is another one based on code written by Bob Jenkins, in C, and
based on a different algorithm included with libucd:

git://git.kernel.org/pub/scm/libs/libucd/libucd.git

It is *much* slower to converge, but probably generates at least
marginally faster lookup code.

	-hpa
