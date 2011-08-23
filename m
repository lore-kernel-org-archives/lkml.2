Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434Ab1HWHCS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 03:02:18 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:38048 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725Ab1HWHCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 03:02:16 -0400
MIME-Version: 1.0
In-Reply-To: <20110823165841.42cbced7ca56a14a41779ae1@canb.auug.org.au>
References: <1314044960.3668.9.camel@lappy>
	<20110823003925.GA30253@infradead.org>
	<CAOJsxLEgm_-N6297kHqSjFLCtX-Vd204S=+4Q=+GW9HYiWj1eg@mail.gmail.com>
	<20110823165841.42cbced7ca56a14a41779ae1@canb.auug.org.au>
Date: Tue, 23 Aug 2011 10:02:15 +0300
X-Google-Sender-Auth: qMUux62qgMAFzp44eI8BZcNpxXc
Message-ID: <CAOJsxLHp7VwS=9rS-xT2xGGDWh7Z0GapqfhNzLtaf9nzpXaDBA@mail.gmail.com>
Subject: Re: linux next: Native Linux KVM tool inclusion request
From: Pekka Enberg <penberg@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Christoph Hellwig <hch@infradead.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-next@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 9:58 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> I will add this to linux-next tomorrow unless people object by then.

Thanks. The code won't cause harm to anyone as it's all under
tools/kvm and doesn't affect people who don't want to use it.

                        Pekka
