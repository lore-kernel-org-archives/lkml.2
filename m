Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040Ab3AGRe1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 12:34:27 -0500
Received: from mail-vb0-f52.google.com ([209.85.212.52]:62332 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969Ab3AGRe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 12:34:26 -0500
MIME-Version: 1.0
In-Reply-To: <CAJd=RBAps4Qk9WLYbQhLkJd8d12NLV0CbjPYC6uqH_-L+Vu0VQ@mail.gmail.com>
References: <20130105152208.GA3386@redhat.com> <CAJd=RBCb0oheRnVCM4okVKFvKGzuLp9GpZJCkVY3RR-J=XEoBA@mail.gmail.com>
 <alpine.LNX.2.00.1301061037140.28950@eggly.anvils> <CAJd=RBAps4Qk9WLYbQhLkJd8d12NLV0CbjPYC6uqH_-L+Vu0VQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 7 Jan 2013 09:34:03 -0800
X-Google-Sender-Auth: qAFHWIQPFkJpn0vaoZawaufwb9k
Message-ID: <CA+55aFyYAf6ztDLsxWFD+6jb++y0YNjso-9j+83Mm+3uQ=8PdA@mail.gmail.com>
Subject: Re: oops in copy_page_rep()
To: Hillf Danton <dhillf@gmail.com>
Cc: Hugh Dickins <hughd@google.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 7, 2013 at 4:24 AM, Hillf Danton <dhillf@gmail.com> wrote:
>
> I take another try with waiting added, take a look please.

Hmm. Is there some reason we never need to worry about it for the
"pmd_numa()" case just above?

A comment about this all might be a really good idea.

                   Linus
