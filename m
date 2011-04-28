Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959Ab1D1TKb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 15:10:31 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:34868 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221Ab1D1TKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 15:10:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=ksplice.com; s=google;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=dZjBRs6l0/RY10KJtbLUXMXJFCjPnhKJrDEu5gmpz4kPyH68Pvi7HX79gpN1OnAGek
         GhdXVec50E9EDIlzf5fV6sPJpVVWzDqoTgbExz9BvYEvE/C1oipwe7vfii+8ka5QwfNx
         rlrach1F5g7UrCx5/rnjvJK7jNmUjrAvYabsM=
MIME-Version: 1.0
In-Reply-To: <20110428184234.GB2559@redhat.com>
References: <alpine.DEB.2.02.1104281346060.14343@dr-wily.mit.edu>
	<20110428184234.GB2559@redhat.com>
Date: Thu, 28 Apr 2011 15:10:27 -0400
Message-ID: <BANLkTikG6atUB1mE8UF8Ew4ustb1gfFEjA@mail.gmail.com>
Subject: Re: [PATCH] jump label: Fix jump_label_text_reserved
From: Anders Kaseorg <andersk@ksplice.com>
To: Jason Baron <jbaron@redhat.com>
Cc: Steven Rostedt <srostedt@redhat.com>,
        Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 14:42, Jason Baron <jbaron@redhat.com> wrote:
> This is fixed in the jump label re-write patch, which is queued for
> 2.6.40 in the -tip tree. See: http://marc.info/?l=linux-kernel&m=130391786701337&w=2

Okay.  It would be nice if the bug fixes had been separated out into
commits that could be picked onto the -stable kernels.  Should I send
my patch to stable@kernel.org?

> I believe only kprobes is relying on this check. Did you hit this in
> practive using kprobes?

Ksplice needs this check too.

Anders
