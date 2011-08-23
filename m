Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929Ab1HWFIH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 01:08:07 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:57205 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab1HWFIF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 01:08:05 -0400
MIME-Version: 1.0
In-Reply-To: <20110823003925.GA30253@infradead.org>
References: <1314044960.3668.9.camel@lappy>
	<20110823003925.GA30253@infradead.org>
Date: Tue, 23 Aug 2011 08:08:02 +0300
X-Google-Sender-Auth: MJVBxy63AyOXqNodEP65UyGckNg
Message-ID: <CAOJsxLEgm_-N6297kHqSjFLCtX-Vd204S=+4Q=+GW9HYiWj1eg@mail.gmail.com>
Subject: Re: linux next: Native Linux KVM tool inclusion request
From: Pekka Enberg <penberg@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-next@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 11:29:20PM +0300, Sasha Levin wrote:
>> I would like to ask you to include the Native Linux KVM tool in the
>> linux-next tree.

On Tue, Aug 23, 2011 at 3:39 AM, Christoph Hellwig <hch@infradead.org> wrote:
> What has changed over the last rejection of it?  Again, I'm not against
> the tool, but there is no reason to throw it into the kernel tree with
> a completely misleading name.

Linus didn't reject it but postponed his decision to the next merge
window. We're going to send a pull request for 3.2 so we'd like the
code to be in linux-next.

As for changes, we've implemented rootfs over 9p with "kvm run"
booting to host filesystem "/bin/sh" by default. It still needs some
work and we hope to enable networking too. We also have patches to use
overlayfs so that the guest is able to use host filesystem in
copy-on-write manner.

                        Pekka
