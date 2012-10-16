Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab2JPOvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 10:51:23 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36697 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab2JPOvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 10:51:22 -0400
MIME-Version: 1.0
In-Reply-To: <20121016134129.2fcd7c8ebe1235065aea929e@canb.auug.org.au>
References: <alpine.LFD.2.02.1210121434140.10531@tux.localdomain> <20121016134129.2fcd7c8ebe1235065aea929e@canb.auug.org.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 16 Oct 2012 07:50:52 -0700
X-Google-Sender-Auth: mdM3V2w8W6MJDr4wT-1WD95P0pA
Message-ID: <CA+55aFzz66Y1MtOoqEMrQCVzdL-2pgr43e1sXUa=eM5GXL9XSA@mail.gmail.com>
Subject: Re: [GIT PULL] Linux KVM tool for v3.7-rc0
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Avi Kivity <avi@redhat.com>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 7:41 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/penberg/linux.git kvmtool/for-linus
>
> So you have not taken this in the v3.7 merge window.
>
> Will you ever merge this?

I have yet to see a compelling argument for merging it. It's tons of
code, it doesnt match the original "small simple" model, and I think
it would be better off as a separate project.

           Linus
