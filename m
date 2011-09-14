Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366Ab1INSjI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 14:39:08 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38101 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757299Ab1INSjF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 14:39:05 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.183.149]
In-Reply-To: <BANLkTi=7TBMqnEf2qustrmSaubtTam79Bw@mail.gmail.com>
References: <1308640714-17961-1-git-send-email-ohad@wizery.com>
 <1308640714-17961-8-git-send-email-ohad@wizery.com> <87liwu8u3q.fsf@rustcorp.com.au>
 <BANLkTi=7TBMqnEf2qustrmSaubtTam79Bw@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 14 Sep 2011 21:38:43 +0300
Message-ID: <CAK=WgbY0zMkHw9XHDKPEfVQZVRfGP=nMmyJgm6jD5FEkBZkMRQ@mail.gmail.com>
Subject: Re: [RFC 7/8] drivers: introduce rpmsg, a remote-processor messaging bus
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
        Brian Swetland <swetland@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        davinci-linux-open-source 
	<davinci-linux-open-source@linux.davincidsp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

On Wed, Jun 22, 2011 at 1:46 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> On Wed, Jun 22, 2011 at 5:42 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>> On Tue, 21 Jun 2011 10:18:33 +0300, Ohad Ben-Cohen <ohad@wizery.com> wrote:
>>> +#define VIRTIO_ID_RPMSG              10 /* virtio remote processor messaging */
>>
>> I think you want 6.  Plan 9 jumped ahead to grab 9 :)
>
> 6 it is :)

Looking at the virtio-spec, it seems that 6 is taken by 'ioMemory'.
There's no indication for it in virtio_ids.h though, and the
virtio-spec has no appendix for this id, so maybe it's available after
all ?

If it is available, I'll take it for rpmsg, and will also update
virtio-spec appropriately. Otherwise, we'll settle on 7 ? :)

Thanks,
Ohad.
