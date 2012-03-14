Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761280Ab2CNTMr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 15:12:47 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53663 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757440Ab2CNTMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 15:12:45 -0400
MIME-Version: 1.0
In-Reply-To: <4F602E2E.8030008@in.ibm.com>
References: <1329841429.10124.38.camel@lappy> <4F602E2E.8030008@in.ibm.com>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Wed, 14 Mar 2012 21:12:25 +0200
Message-ID: <CA+1xoqc2+HwfyyHUjJr9kFG9Y1esW6nxj=4djYwYx9vF0nSByw@mail.gmail.com>
Subject: Re: [V9fs-developer] 9p: BUG: unable to handle kernel paging request
 at ffff880035698000
To: "M. Mohan Kumar" <mohan@in.ibm.com>
Cc: ericvh@gmail.com, rminnich@sandia.gov, lucho@ionkov.net,
        v9fs-developer@lists.sourceforge.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 7:35 AM, M. Mohan Kumar <mohan@in.ibm.com> wrote:
> On 02/21/2012 09:53 PM, Sasha Levin wrote:
>>
>> Hi,
>>
>> I was using the KVM tool for tests with trinity on top of a virtio-9p
>> filesystem, and started seeing the BUGs below when I've put some pressure on
>> the 9p fs (not much, just started writing the logs from trinity to a 9p fs).
>
> Hi Sasha,
>
> You mentioned about testing with trinity, Where can I find this trinity ? Is
> is some test suite ? Were you running 9p as root?

I was using the fuzzer linked by davej in the previous mail.

9p was the root partition, and there was another 9p partition mounted
on top of that root 9p.

> Which kernel version you were using? Is this bug still reproducible?

It was running the linux-next kernel of the day I sent the mail, I
don't see it happening any more - but it could be because a lot of new
kernel bugs showed up and they happen before this 9p issue happens.
