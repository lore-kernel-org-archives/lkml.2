Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933065Ab1FQUEb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 16:04:31 -0400
Received: from outmail015.snc4.facebook.com ([66.220.144.147]:37237 "EHLO
	mx-out.facebook.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932993Ab1FQUEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 16:04:30 -0400
Message-ID: <4DFBB37C.2060004@fb.com>
Date: Fri, 17 Jun 2011 13:05:16 -0700
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH] atomic: cleanup asm-generic atomic*.h inclusion
References: <20110615163115.773d072e.akpm@linux-foundation.org> <1308187784-3815-1-git-send-email-asharma@fb.com> <BANLkTi=f2N+dO2nBLobM73jCg0U0QSqxNQ@mail.gmail.com> <4DFB8AAF.1040002@fb.com> <BANLkTindmEA7NsaRjuukh1-oRCtVWpeuCA@mail.gmail.com> <4DFB93C1.9000901@fb.com> <BANLkTim5zEo=Rn2sqUExL-8n=p4inLEpuQ@mail.gmail.com> <4DFBA001.4010500@fb.com> <BANLkTinQhBfAJd5-ZaPXbiV778c9fvXeWg@mail.gmail.com>
In-Reply-To: <BANLkTinQhBfAJd5-ZaPXbiV778c9fvXeWg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/17/11 12:07 PM, Mike Frysinger wrote:

>> <linux/atomic.h>  a header file that's usable in machine independent kernel
>> code.
>
> if that's the direction we want to take things, then this needs to be
> documented at the top of both files.  i also see quite a lot of
> primitives in asm-generic/atomic.h that would be better placed using
> your definitions in linux/atomic.h.
>

I incorporated your feedback in the patch set I just sent out. Thanks 
for the review. Please let me know if the new patch set works better for 
you.

  -Arun
