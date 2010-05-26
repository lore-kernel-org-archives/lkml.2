Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933931Ab0EZCX0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 22:23:26 -0400
Received: from mail.codesourcery.com ([38.113.113.100]:57835 "EHLO
	mail.codesourcery.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933465Ab0EZCXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 22:23:24 -0400
Message-ID: <4BFC8617.9010501@codesourcery.com>
Date: Wed, 26 May 2010 10:23:19 +0800
From: Jie Zhang <jie@codesourcery.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 Lightning/1.0b1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: Paul Mundt <lethal@linux-sh.org>, Mike Frysinger <vapier@gentoo.org>,
       uclinux-dev@uclinux.org, David Howells <dhowells@redhat.com>,
       David McCullough <davidm@snapgear.com>, Greg Ungerer <gerg@uclinux.org>,
       uclinux-dist-devel@blackfin.uclinux.org,
       microblaze-uclinux@itee.uq.edu.au, Michal Simek <monstr@monstr.eu>,
       linux-m32r@ml.linux-m32r.org, Hirokazu Takata <takata@linux-m32r.org>,
       linux-kernel@vger.kernel.org,
       Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: Re: [PATCH] FLAT: allow arches to declare a larger alignment than
 the 	slab
References: <1274815467-14584-1-git-send-email-vapier@gentoo.org> 	<20100525210755.GA8920@linux-sh.org> <AANLkTinTbJ3yu9ElO32rnavnGwCrsItdDCl58KoeEW3j@mail.gmail.com>
In-Reply-To: <AANLkTinTbJ3yu9ElO32rnavnGwCrsItdDCl58KoeEW3j@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2010 07:17 AM, Mike Frysinger wrote:
> i do not believe that is the reason for this, but unfortunately Jie is
> about the only one atm who knows the inner details as for why shared
> FLAT libraries requires 0x20 rather than just 0x4 alignment.  i do
> know that there are some gcc fortran tests that fail otherwise.
> hopefully he can remember details ;).
>
I encountered this issue when investigating some GCC test failures when 
using FLAT. I don't remember if they were in GCC Fortran testsuite. Some 
variables in those test cases were required to be aligned at a large 
boundary, for example 16-byte. I found 0x20 was a reasonably large 
alignment to fix all such failures in GCC testsuite.


Jie
