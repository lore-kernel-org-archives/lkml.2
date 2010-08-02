Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab0HBSF0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 14:05:26 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42580 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940Ab0HBSFZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 14:05:25 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTimFhNG0WVXURsjhHAisbrAK20zFgReydJ6AG1WJ@mail.gmail.com>
References: <AANLkTik7powjUaJ51bA_bgPVb03U-RVZay3NffHBYLzx@mail.gmail.com>
	<AANLkTimxc5dsvhW=__OP=tSP0jHPyU1G7jVLCV-wz9im@mail.gmail.com>
	<AANLkTimFhNG0WVXURsjhHAisbrAK20zFgReydJ6AG1WJ@mail.gmail.com>
Date: Mon, 2 Aug 2010 19:05:14 +0100
Message-ID: <AANLkTi=SLDRXFYMB28sjb9tuaroOmXgN6_YMGFW7+wz7@mail.gmail.com>
Subject: Re: a Great Idea - include Kademlia networking protocol in kernel
From: Valeo de Vries <valeo@valeo.co.cc>
To: hp fk <fkhp101@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 August 2010 16:33, hp fk <fkhp101@gmail.com> wrote:
> 2010/8/2 Valeo de Vries <valeo@valeo.co.cc>:
>
>> And why exactly can't this be done in userspace? I assume that since
>> you mention IP that (perhaps incorrectly) this protocol uses TCP/UDP
>> on the lower layers...
>
> using userspace p2p network service and  library might be another way
> to consolidate the protocol.
> in kernel  or in userspace service/library, each will have its own
> advantage and disadvantage.  like qemu-kvm and qemu userspace.

Sorry, but no. You're suggesting adding a protocol to the kernel that
fits better in userspace without actually coming up with any reasons
why having it in-kernel would be better. Not to mention that adding
yet another protocol to the kernel means more vectors for possible
exploits.

Valeo
