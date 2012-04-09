Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab2DIUsG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 16:48:06 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:54629 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab2DIUr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 16:47:56 -0400
MIME-Version: 1.0
In-Reply-To: <CABqD9haT5h-7LMkbGSaQbnk8SJj9L21GT61UZCMVWLJCTw9OBg@mail.gmail.com>
References: <1333051320-30872-1-git-send-email-wad@chromium.org>
 <1333051320-30872-16-git-send-email-wad@chromium.org> <20120406142644.223ffff0.akpm@linux-foundation.org>
 <CABqD9haT5h-7LMkbGSaQbnk8SJj9L21GT61UZCMVWLJCTw9OBg@mail.gmail.com>
From: Markus Gutschke <markus@chromium.org>
Date: Mon, 9 Apr 2012 13:47:30 -0700
X-Google-Sender-Auth: vL4glrHKEcS7Kux7den9505dLO8
Message-ID: <CAE6n16kMv5Y+Cp9XZ=tmK0sgoJJZ6CJUq_ttuNEUMb4JFXJ33g@mail.gmail.com>
Subject: Re: [PATCH v17 15/15] Documentation: prctl/seccomp_filter
To: Will Drewry <wad@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com,
        netdev@vger.kernel.org, x86@kernel.org, arnd@arndb.de,
        davem@davemloft.net, hpa@zytor.com, mingo@redhat.com, oleg@redhat.com,
        peterz@infradead.org, rdunlap@xenotime.net, mcgrathr@chromium.org,
        tglx@linutronix.de, luto@mit.edu, eparis@redhat.com,
        serge.hallyn@canonical.com, djm@mindrot.org, scarybeasts@gmail.com,
        indan@nul.nu, pmoore@redhat.com, corbet@lwn.net,
        eric.dumazet@gmail.com, coreyb@linux.vnet.ibm.com,
        keescook@chromium.org, jmorris@namei.org
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No matter what you do, please leave the samples accessible somewhere.
They proved incredibly useful in figuring out how the API works. I am
sure, other developers are going to appreciate them as well.

Alternatively, if you don't want to include the samples with the
kernel sources, figure out how you can include a sample in the
official manual page for prctl().


Markus
