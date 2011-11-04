Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195Ab1KDMfU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 08:35:20 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:53474 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab1KDMfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 08:35:18 -0400
MIME-Version: 1.0
In-Reply-To: <20111104121601.GA15206@infradead.org>
References: <alpine.LFD.2.02.1111041037290.16959@tux.localdomain>
	<20111104121601.GA15206@infradead.org>
Date: Fri, 4 Nov 2011 14:35:18 +0200
X-Google-Sender-Auth: JQuB-Inbvx8jHX6FSFfwqnQA76Y
Message-ID: <CAOJsxLGf78q7rR7-q4d6TizmghFcKyK3tFOAew4i2-SHrZcvhQ@mail.gmail.com>
Subject: Re: [RFC/GIT PULL] Linux KVM tool for v3.2
From: Pekka Enberg <penberg@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 04, 2011 at 10:38:21AM +0200, Pekka Enberg wrote:
>> Please consider pulling the latest KVM tool tree from:

On Fri, Nov 4, 2011 at 2:16 PM, Christoph Hellwig <hch@infradead.org> wrote:
> There still is absolutely zero reason to throw it in the kernel tree.
>
> Please prepare a nice standalone git repository and tarball for it.

We are reusing kernel code and headers and I am not interested in
copying them over. Living in the kernel tree is part of the design,
whether you like it or not.

                        Pekka
