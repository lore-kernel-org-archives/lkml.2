Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054Ab2BOIv1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 03:51:27 -0500
Received: from mail-lpp01m020-f174.google.com ([209.85.217.174]:59675 "EHLO
	mail-lpp01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755995Ab2BOIv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 03:51:26 -0500
MIME-Version: 1.0
Date: Wed, 15 Feb 2012 09:51:24 +0100
Message-ID: <CA+rthh-JU-CE2t=BvpuZyZt5_1sm4urWrmZN8MmA4iC5JorDmQ@mail.gmail.com>
Subject: AES-NI data corruption issues
From: Mathias Krause <minipli@googlemail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.hengli.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

in commit 5b1cbac3.. ("i387: make irq_fpu_usable() tests more robust")
you wrote on a side note:

    So this explicitly verifies that we will not touch the TS_USEDFPU bit,
    and adds a few related sanity-checks.  Because it seems that somehow
    AES-NI is corrupting user FP state.  The cause is not clear, and this
    patch doesn't fix it, but while debugging it I really wanted the code to
    be more obviously correct and robust.

Can you please elaborate a little more on the AES-NI issues you're
seeing as I cannot find any information about them on
LKML/bugzilla/linux-crypto? Are they limited to the 3.3-rc kernels or
are they happening on released kernels as well? Are they happening on
32 bit, 64 bit or both?

I'm using aesni-intel.ko and fear my data may vanish, albeit I haven't
observed any data corruption so far.


Regards,
Mathias
