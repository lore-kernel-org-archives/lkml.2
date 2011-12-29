Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539Ab1L2Chs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 21:37:48 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43769 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab1L2Chq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 21:37:46 -0500
MIME-Version: 1.0
In-Reply-To: <1325115628.2029.1.camel@shrek.rexursive.com>
References: <CAGsJ_4yXU62GZ38fe7TCH8uKLHJvZ8jtFbJLywqv1kgC7y9V_A@mail.gmail.com>
 <1325115628.2029.1.camel@shrek.rexursive.com>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 29 Dec 2011 10:37:24 +0800
Message-ID: <CAGsJ_4xH-9MXq8UJJFLW=upBqK+PXbWfDJhttBN=n2_M0PzMSw@mail.gmail.com>
Subject: Re: [PATCH] PM / Hibernate: Improve performance of LZO/plain
 hibernation, checksum image
To: Bojan Smojver <bojan@rexursive.com>
Cc: rjw@sisk.pl, linux-pm@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/12/29 Bojan Smojver <bojan@rexursive.com>:
> On Tue, 2011-12-27 at 20:27 +0800, Barry Song wrote:
>> this patch is definitely great!
>
> Thanks, I'm glad you liked it.
>
>> any plan to write the same patch for decompress and restore? i think
>> that is probably more important than compression and hibernation to
>> improve bootup speed.
>
> I'm not sure I understand what you mean here. Can you elaborate?

i mean we can load image and decompress them in different threads when
we reboot from hibernation.
after i read codes more carefully, that has actually been done by
lzo_decompress_threadfn().

here the problem is we didn't seem to get any faster after applying
your compression patch when doing hibernation on SD/NAND.
we are trying to figure out the reason.

>
> --
> Bojan
>

-barry
