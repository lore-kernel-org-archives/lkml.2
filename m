Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032Ab2DIU7l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 16:59:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:12684 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756487Ab2DIU7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 16:59:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="126998889"
User-Agent: Microsoft-MacOutlook/14.14.0.111121
Date: Mon, 09 Apr 2012 13:58:56 -0700
Subject: Re: [PATCH v17 15/15] Documentation: prctl/seccomp_filter
From: Ryan Ware <ware@linux.intel.com>
To: Markus Gutschke <markus@chromium.org>, Will Drewry <wad@chromium.org>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <kernel-hardening@lists.openwall.com>,
        <netdev@vger.kernel.org>, <x86@kernel.org>, <arnd@arndb.de>,
        <davem@davemloft.net>, <hpa@zytor.com>, <mingo@redhat.com>,
        <oleg@redhat.com>, <peterz@infradead.org>, <rdunlap@xenotime.net>,
        <mcgrathr@chromium.org>, <tglx@linutronix.de>, <luto@mit.edu>,
        <eparis@redhat.com>, <serge.hallyn@canonical.com>, <djm@mindrot.org>,
        <scarybeasts@gmail.com>, <indan@nul.nu>, <pmoore@redhat.com>,
        <corbet@lwn.net>, <eric.dumazet@gmail.com>,
        <coreyb@linux.vnet.ibm.com>, <keescook@chromium.org>,
        <jmorris@namei.org>
Message-ID: <CBA89B80.3C770%ware@linux.intel.com>
Thread-Topic: [PATCH v17 15/15] Documentation: prctl/seccomp_filter
In-Reply-To: <CAE6n16kMv5Y+Cp9XZ=tmK0sgoJJZ6CJUq_ttuNEUMb4JFXJ33g@mail.gmail.com>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I second this!  They are extremely useful.

Ryan

On 4/9/12 1:47 PM, "Markus Gutschke" <markus@chromium.org> wrote:

>No matter what you do, please leave the samples accessible somewhere.
>They proved incredibly useful in figuring out how the API works. I am
>sure, other developers are going to appreciate them as well.
>
>Alternatively, if you don't want to include the samples with the
>kernel sources, figure out how you can include a sample in the
>official manual page for prctl().
>
>
>Markus
>--
>To unsubscribe from this list: send the line "unsubscribe
>linux-security-module" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html


