Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540Ab2EHPdt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 11:33:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38805 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755460Ab2EHPds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 11:33:48 -0400
MIME-Version: 1.0
In-Reply-To: <CAPXgP11882vP5GtMmwdsw-w6-D6q9NXHNsHem3Ump17__r2xOQ@mail.gmail.com>
References: <1336004953.4240.9.camel@mop> <CA+1xoqdCk9FcqdLEvwgHtfrauNh=s0dDwcpaJimMC_H83N=_5w@mail.gmail.com>
 <1336475689.1179.12.camel@mop> <CA+1xoqdk_yGQyX+6yHyvHsQ1hXiraOzbhVZAgmLmmtMtVTPeGQ@mail.gmail.com>
 <CAPXgP11882vP5GtMmwdsw-w6-D6q9NXHNsHem3Ump17__r2xOQ@mail.gmail.com>
From: Kay Sievers <kay@vrfy.org>
Date: Tue, 8 May 2012 17:33:27 +0200
Message-ID: <CAPXgP11G9Tv37qTy_kLcYphosUXc+2uQDzU6BYekGdVt3Oye4A@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to variable-length
 record buffer
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Greg Kroah-Hartmann <greg@kroah.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 8, 2012 at 4:29 PM, Kay Sievers <kay@vrfy.org> wrote:
> On Tue, May 8, 2012 at 3:33 PM, Sasha Levin <levinsasha928@gmail.com> wrote:

>> if you're ok with it I can try patching those myself.
>
> That would be awesome. If you decide otherwise, please let me know,
> and I'll take care of them.

Sent the rest out, which got lost a while ago. Here's the already
fixed and pending stuff, so you can check what's not covered and still
missing on your box.

percpu:
  http://thread.gmane.org/gmane.linux.kernel/1274450

mm:
  http://thread.gmane.org/gmane.linux.kernel/1293437

acpi:
  http://thread.gmane.org/gmane.linux.kernel/1293438

Thanks,
Kay
