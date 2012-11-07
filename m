Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab2KHABY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 19:01:24 -0500
Received: from ozlabs.org ([203.10.76.45]:47545 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130Ab2KHABW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 19:01:22 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Lee Jones <lee.jones@linaro.org>, Pawel Moll <pawel.moll@arm.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio-mmio: Fix irq parsing in command line parameter
In-Reply-To: <20121105134413.GC5220@gmail.com>
References: <1352120454.10947.5.camel@hornet> <1352120572-16256-1-git-send-email-pawel.moll@arm.com> <20121105134413.GC5220@gmail.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 08 Nov 2012 08:52:41 +1030
Message-ID: <87bof93vf2.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lee Jones <lee.jones@linaro.org> writes:
> On Mon, 05 Nov 2012, Pawel Moll wrote:
>
>> On 64-bit machines resource_size_t is a 64-bit value, while
>> sscanf() format for this argument was defined as "%u". Fixed
>> by using an intermediate local value of a known length.
>> 
>> Also added cleaned up the resource creation and adde extra
>> comments to make the parameters parsing easier to follow.
>> 
>> Reported-by: Lee Jones <lee.jones@linaro.org>
>> Signed-off-by: Pawel Moll <pawel.moll@arm.com>
>> ---
>>  drivers/virtio/virtio_mmio.c |   26 ++++++++++++++++++--------
>>  1 file changed, 18 insertions(+), 8 deletions(-)
>
> Resorted to poaching now have we Pawel? ;)

I hope you were joking!  Doing your work for you isn't poaching.

Your correct response was "thanks" followed by 'Tested-by:'.

Cheers,
Rusty.
