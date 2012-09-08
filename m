Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760085Ab2IHB7R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 21:59:17 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57899 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab2IHB7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 21:59:16 -0400
MIME-Version: 1.0
In-Reply-To: <504AA2F9.5060502@cn.fujitsu.com>
References: <1346750580-11352-1-git-send-email-gaowanlong@cn.fujitsu.com>
 <CAHGf_=o8VzFSF3kGK92bKgeWPJ4qOQ_NhCzXO-J_Ge22M7M20g@mail.gmail.com> <504AA2F9.5060502@cn.fujitsu.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Fri, 7 Sep 2012 21:58:55 -0400
X-Google-Sender-Auth: 3heyd7qoFOe65u9OQWI8KKklFxQ
Message-ID: <CAHGf_=rPYAU6X2eXqyBxHV=PtguBceK=n_C89dTDbUk54-+6ww@mail.gmail.com>
Subject: Re: [PATCH] mm: fix mmap overflow checking
To: gaowanlong@cn.fujitsu.com
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        open@kvack.org,
        "list@kvack.org:MEMORY MANAGEMENT" <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I've seen the exactly same patch from another fujitsu guys several
>> month ago. and as I pointed
>> out at that time, this line don't work when 32bit kernel + mmap2 syscall case.
>>
>> Please don't think do_mmap_pgoff() is for mmap(2) specific and read a
>> past thread before resend
>> a patch.
>
> So, what's your opinion about this bug? How to fix it in your mind?

Fix glibc instead of kernel.
