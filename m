Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab0IAA7h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 20:59:37 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:48187 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab0IAA7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 20:59:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=TzbTKq/YsQ3X+V8CjMsklb/qoWsPqc+DstlhcSsZEmN87XShXXoY2OKQOaYaJC8m+V
         JUn66wA1KXMdV7c2pdQ1iSgNUq65Ic1hTqQSSz4PWnedBwhOkoe0dP98o87rAr/8nkKM
         KCbHSkzRLkYpiKGidkkqBH6t9fLqSypmbw0EU=
Subject: Re: [Question] How to test (DRAM) memory location.
From: Calvin Walton <calvin.walton@gmail.com>
To: santosh <santosh.iitg@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTim03ofVGh-5ifAfook=nv35tY0RDKMjHsEW8U1N@mail.gmail.com>
References: <AANLkTinYuck4yEGpFDKZp-R3N2dtoQ68cLHQY6EW6sr-@mail.gmail.com>
	 <1283216269.3738.6.camel@ayu>
	 <AANLkTim03ofVGh-5ifAfook=nv35tY0RDKMjHsEW8U1N@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 Aug 2010 20:59:33 -0400
Message-ID: <1283302773.3754.5.camel@nayuki>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-31 at 18:07 +0530, santosh wrote:
> hi Calvin,
> 
> > There's some work done on an in-kernel memory tester, but testing memory
> > while Linux is running is somewhat limited as there are sections of
> > memory that you can't overwrite during testing. Take a look at
> > CONFIG_MEMTEST and arch/x86/mm/memtest.c (which is currently only
> > capable of testing memory in early boot).
> >
> 
> I was just looking at "linux-source-2.6.27.48" but could not find
> "memtest.c" at the location you mentioned above:
> 
> [root@localhost linux-2.6.27.48]# cd arch/x86/mm/

This code was moved fairly recently, although I don't remember exactly
when. In the kernel version you have, it should be present in
arch/x86/mm/init_64.c
(and is only available on the 64-bit x86 architecture).

Please check a newer kernel if you can, there's been some improvements
since.

-- 
Calvin Walton <calvin.walton@gmail.com>

