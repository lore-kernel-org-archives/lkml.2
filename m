Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab2DBUvb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 16:51:31 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54235 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359Ab2DBUva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 16:51:30 -0400
MIME-Version: 1.0
In-Reply-To: <1333399194.6431.3.camel@lorien2>
References: <20120117235852.GA4877@www.outflux.net>
	<20120118140603.0fc22302.akpm@linux-foundation.org>
	<CAGXu5jKiPaChjvjA7r12mSH2W0r-X4EdFpQMMMaBOL+C=3UftA@mail.gmail.com>
	<5C4C569E8A4B9B42A84A977CF070A35B2DA7A7F226@USINDEVS01.corp.hds.com>
	<4F1A7854.7010808@gmail.com>
	<1333399194.6431.3.camel@lorien2>
Date: Mon, 2 Apr 2012 13:51:29 -0700
X-Google-Sender-Auth: sRNgmOzk_tRe_0Bl-mZOa_wlYRw
Message-ID: <CAGXu5jL-QP6LUqc_JY-JevNbrsRUpiP337pfUH4m1CA-+jm_RQ@mail.gmail.com>
Subject: Re: [PATCH v5] ramoops: use pstore interface
From: Kees Cook <keescook@chromium.org>
To: shuahkhan@gmail.com, Matt Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 2, 2012 at 1:39 PM, Shuah Khan <shuahkhan@gmail.com> wrote:
>> First of all ramoops was born mainly for debug purpose and to help the
>> maintainability of a product. I used it in systems where the uptime (so
>> no reboot) was important. So it can be very useful for me load the
>> module, gather logs and unload it for example. A kernel panic is not
>> recoverable so the reboot is needed but it's not always true for a
>> kernel oops.
>>
>> Marco
>
> What is the status of this patch? Don't see it in 3.3 and haven't
> checked 3.4-rc1 yet.

Hi,

I've been hoping it would get into 3.4. It's in the -mm tree, and has
been living in linux-next for a while. I'm not sure why it hasn't been
merged into Linus's tree yet. Andrew, is there a reason it hasn't been
merged?

http://marc.info/?l=linux-mm-commits&m=132692455101733&w=4

http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commitdiff;h=07eff225ead22b21fe5aba32cd2695248a9e4d1f

-Kees

-- 
Kees Cook
ChromeOS Security
