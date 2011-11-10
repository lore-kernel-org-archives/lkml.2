Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935018Ab1KJOrk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 09:47:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23788 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934970Ab1KJOri convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 09:47:38 -0500
From: Markus Armbruster <armbru@redhat.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Anthony Liguori <anthony@codemonkey.ws>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC/GIT PULL] Linux KVM tool for v3.2
References: <alpine.LFD.2.02.1111041037290.16959@tux.localdomain>
	<4EBB4A21.20707@codemonkey.ws>
	<alpine.LFD.2.02.1111100829560.1791@tux.localdomain>
	<4EBBD503.4020308@codemonkey.ws>
	<CAOJsxLH+Afuk-42aPwd9hcvhpmCD88t4-2N02M5oz8LBNZYETA@mail.gmail.com>
Date: Thu, 10 Nov 2011 15:47:28 +0100
In-Reply-To: <CAOJsxLH+Afuk-42aPwd9hcvhpmCD88t4-2N02M5oz8LBNZYETA@mail.gmail.com>
	(Pekka Enberg's message of "Thu, 10 Nov 2011 15:56:17 +0200")
Message-ID: <m3vcqsghkv.fsf@blackfin.pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg <penberg@kernel.org> writes:

> Hi Anthony,
>
> On Thu, Nov 10, 2011 at 3:43 PM, Anthony Liguori <anthony@codemonkey.ws> wrote:
>> It's not just the qcow2 implementation or even the block layer.  This pull
>> requests adds a userspace TCP/IP stack to the kernel and yet netdev isn't on
>> the CC and there are no Ack's from anyone from the networking stack.  I'm
>> fairly sure if they knew what was happening here they would object.
>
> It's something we consider extremely important because it allows easy
> non-root networking. But you're right, we definitely ought to ping the
> networking folks before the next merge window.

The problem is real.  The solution "duplicate in user space" sucks.  If
you engaging with the kernel networking folks leads to one that doesn't
suck, we should bathe you in free beer.
