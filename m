Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163Ab2DIWsD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 18:48:03 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:42084 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758070Ab2DIWr7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 18:47:59 -0400
MIME-Version: 1.0
In-Reply-To: <CBA89B80.3C770%ware@linux.intel.com>
References: <CAE6n16kMv5Y+Cp9XZ=tmK0sgoJJZ6CJUq_ttuNEUMb4JFXJ33g@mail.gmail.com>
	<CBA89B80.3C770%ware@linux.intel.com>
Date: Mon, 9 Apr 2012 17:47:55 -0500
Message-ID: <CABqD9hYQPDmNadkPw9O6fRXHpWDxh=MVPf7VB_3fz_X72dNz4w@mail.gmail.com>
Subject: Re: [PATCH v17 15/15] Documentation: prctl/seccomp_filter
From: Will Drewry <wad@chromium.org>
To: Ryan Ware <ware@linux.intel.com>, Markus Gutschke <markus@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
        kernel-hardening@lists.openwall.com, netdev@vger.kernel.org,
        x86@kernel.org, arnd@arndb.de, davem@davemloft.net, hpa@zytor.com,
        mingo@redhat.com, oleg@redhat.com, peterz@infradead.org,
        rdunlap@xenotime.net, mcgrathr@chromium.org, tglx@linutronix.de,
        luto@mit.edu, eparis@redhat.com, serge.hallyn@canonical.com,
        djm@mindrot.org, scarybeasts@gmail.com, indan@nul.nu,
        pmoore@redhat.com, corbet@lwn.net, eric.dumazet@gmail.com,
        coreyb@linux.vnet.ibm.com, keescook@chromium.org, jmorris@namei.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 9, 2012 at 3:58 PM, Ryan Ware <ware@linux.intel.com> wrote:
>
> On 4/9/12 1:47 PM, "Markus Gutschke" <markus@chromium.org> wrote:
>
>>No matter what you do, please leave the samples accessible somewhere.
>>They proved incredibly useful in figuring out how the API works. I am
>>sure, other developers are going to appreciate them as well.
>>
>>Alternatively, if you don't want to include the samples with the
>>kernel sources, figure out how you can include a sample in the
>>official manual page for prctl().
>>
>
> I second this!  They are extremely useful.
>
> Ryan

In that case, would it make sense to put up a separate tools/testing
patch and leave samples where they lie? (I'd _love_ to keep this patch
series from acquiring another 1000 lines, but either way works :)

My current tester and harness lives here:
  https://github.com/redpig/seccomp/blob/master/tests/
and the licensing can be sorted out prior to a patch mail.

thanks!
will
