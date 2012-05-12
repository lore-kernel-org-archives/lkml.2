Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271Ab2ELW34 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 18:29:56 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:46521 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab2ELW3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 18:29:55 -0400
MIME-Version: 1.0
In-Reply-To: <20120512212531.GC20057@infradead.org>
References: <1336852387-16322-1-git-send-email-acme@infradead.org>
 <CA+55aFxeqrCj71fSe2r9kwzyO9q2BT9A89f7nLUgbrTG_uPP2g@mail.gmail.com> <20120512212531.GC20057@infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 12 May 2012 15:29:34 -0700
X-Google-Sender-Auth: aIQvLY3LfdNRdqL1wTa9u-XNNC8
Message-ID: <CA+55aFzGAokE5htNFhkoRxT5bK1_5=uofkC5xZipTtiawSh_hA@mail.gmail.com>
Subject: Re: [GIT PULL 0/8] Annotation weekly ponies delivery
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Arjan van de Ven <arjan@infradead.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 12, 2012 at 2:25 PM, Arnaldo Carvalho de Melo
<acme@infradead.org> wrote:
>
> Didn't notice it, but then I'm not updating the kernel that frequently,
> will check on this Sandy Bridge nobo (i7-2920XM).

I think SNB has problems with PEBS and cycles anyway. I have a
westmere machine that I use for profiling for that reason.

                  Linus
