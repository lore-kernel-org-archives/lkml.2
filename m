Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757192Ab2EHP56 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 11:57:58 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:42991 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757022Ab2EHP55 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 11:57:57 -0400
MIME-Version: 1.0
In-Reply-To: <CAPXgP11G9Tv37qTy_kLcYphosUXc+2uQDzU6BYekGdVt3Oye4A@mail.gmail.com>
References: <1336004953.4240.9.camel@mop> <CA+1xoqdCk9FcqdLEvwgHtfrauNh=s0dDwcpaJimMC_H83N=_5w@mail.gmail.com>
 <1336475689.1179.12.camel@mop> <CA+1xoqdk_yGQyX+6yHyvHsQ1hXiraOzbhVZAgmLmmtMtVTPeGQ@mail.gmail.com>
 <CAPXgP11882vP5GtMmwdsw-w6-D6q9NXHNsHem3Ump17__r2xOQ@mail.gmail.com> <CAPXgP11G9Tv37qTy_kLcYphosUXc+2uQDzU6BYekGdVt3Oye4A@mail.gmail.com>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Tue, 8 May 2012 17:57:35 +0200
Message-ID: <CA+1xoqenmuF+K7SAajM5L7zSkKxVKbN7GAdhMJmNjCNW1VQ3Yg@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to variable-length
 record buffer
To: Kay Sievers <kay@vrfy.org>
Cc: Greg Kroah-Hartmann <greg@kroah.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 8, 2012 at 5:33 PM, Kay Sievers <kay@vrfy.org> wrote:
> On Tue, May 8, 2012 at 4:29 PM, Kay Sievers <kay@vrfy.org> wrote:
>> On Tue, May 8, 2012 at 3:33 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
>
>>> if you're ok with it I can try patching those myself.
>>
>> That would be awesome. If you decide otherwise, please let me know,
>> and I'll take care of them.
>
> Sent the rest out, which got lost a while ago. Here's the already
> fixed and pending stuff, so you can check what's not covered and still
> missing on your box.

> mm:
>  http://thread.gmane.org/gmane.linux.kernel/1293437

Woops, look like I've did this one all over.


What about PRINTK_TIME? Are there plans to enable it on console output?
