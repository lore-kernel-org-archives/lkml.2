Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751314Ab1AWI3p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 03:29:45 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41252 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab1AWI3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 03:29:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=SUVL6pnq4eyCcHh3zlpOI+7A1RoP/2b28HN9kWN/imLylvwMTzVyIEGFBmLX7hKY5m
         89TgQ+QFRwvsNQGX/OyJcVv0Tea+D8KSW9mvUX6tbDYLoLFbNbYRZh3Q9s+DRgraeKO5
         4xqQkZdwwvnEzXP1DJE9mRXKQKaVKnFWtXpfU=
Subject: Re: [PATCH 1/6] perf test: Fix build on older glibcs
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
In-Reply-To: <1295747778-26186-2-git-send-email-acme@infradead.org>
References: <1295747778-26186-1-git-send-email-acme@infradead.org>
	 <1295747778-26186-2-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 23 Jan 2011 09:29:36 +0100
Message-ID: <1295771376.17333.1.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 22 janvier 2011 à 23:56 -0200, Arnaldo Carvalho de Melo a
écrit :
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> Where we don't have CPU_ALLOC & friends. As the tools are being used in older
> distros where the only allowed change are to replace the kernel, like RHEL4 and
> 5.
> 
> Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Stephane Eranian <eranian@google.com>
> LKML-Reference: <new-submission>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---

Hi Arnaldo

I tested the preliminary version you sent me, it worked well, but I
could not apply this patch to current linux-2.6


Thanks !


