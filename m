Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934674Ab1KJN4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 08:56:20 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:39545 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932574Ab1KJN4T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 08:56:19 -0500
MIME-Version: 1.0
In-Reply-To: <4EBBD503.4020308@codemonkey.ws>
References: <alpine.LFD.2.02.1111041037290.16959@tux.localdomain>
	<4EBB4A21.20707@codemonkey.ws>
	<alpine.LFD.2.02.1111100829560.1791@tux.localdomain>
	<4EBBD503.4020308@codemonkey.ws>
Date: Thu, 10 Nov 2011 15:56:17 +0200
X-Google-Sender-Auth: auJimOMeadjab9gPjodAi0qzFdo
Message-ID: <CAOJsxLH+Afuk-42aPwd9hcvhpmCD88t4-2N02M5oz8LBNZYETA@mail.gmail.com>
Subject: Re: [RFC/GIT PULL] Linux KVM tool for v3.2
From: Pekka Enberg <penberg@kernel.org>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anthony,

On Thu, Nov 10, 2011 at 3:43 PM, Anthony Liguori <anthony@codemonkey.ws> wrote:
> It's not just the qcow2 implementation or even the block layer.  This pull
> requests adds a userspace TCP/IP stack to the kernel and yet netdev isn't on
> the CC and there are no Ack's from anyone from the networking stack.  I'm
> fairly sure if they knew what was happening here they would object.

It's something we consider extremely important because it allows easy
non-root networking. But you're right, we definitely ought to ping the
networking folks before the next merge window.

On Thu, Nov 10, 2011 at 3:43 PM, Anthony Liguori <anthony@codemonkey.ws> wrote:
>> Would you be interested in spending another 30 seconds to find out some
>> more issue? :-)
>
> I could, provided you could take the things you want to do differently and
> submit them as patches to qemu.git instead of creating a new tool.
>
> There are lots of people on qemu-devel than can provide deep review of this
> type of code.  That's the advantage of working in qemu.git.

I fully understand if you don't want to spend your time reviewing the
KVM tool code. I'm just saying that if you do spend the next 30
seconds next time you're bored, I'm all ears and happy to fix any
issues you point out.

                        Pekka
