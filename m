Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111Ab0JOEaX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 00:30:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46146 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750856Ab0JOEaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 00:30:22 -0400
Message-ID: <4CB7D8DC.6010003@zytor.com>
Date: Thu, 14 Oct 2010 21:30:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Rong Xu <rong.xu3@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: kernel won't boot if kernel image passes 0xffffffff82000000
References: <AANLkTi=29x3ng4uhUAMewe5Gr25ayDknJS9iGS4c51Yw@mail.gmail.com>
In-Reply-To: <AANLkTi=29x3ng4uhUAMewe5Gr25ayDknJS9iGS4c51Yw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2010 04:58 PM, Rong Xu wrote:
> 
> I tried kernel 2.6.27 and it seems to have the same issue.
> 
> Any comment?

2.6.26/27 are old kernels.  The current kernel is 2.6.35, with 2.6.36
coming out very soon.

As far as I know, this problem was found and fixed about two years ago,
but if you could verify that so is indeed the case that would be useful.

Thanks,

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

