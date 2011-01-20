Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056Ab1ATGq7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 01:46:59 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:60268 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833Ab1ATGq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 01:46:57 -0500
Message-ID: <4D37DAD7.3050100@oracle.com>
Date: Thu, 20 Jan 2011 12:18:55 +0530
From: Gurudas Pai <gurudas.pai@oracle.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Miklos Szeredi <miklos@szeredi.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG] kernel BUG at mm/truncate.c:479! on 2.6.37-rc8
References: <4D1AD935.1020504@oracle.com> <alpine.LSU.2.00.1012291137080.6381@sister.anvils> <4D1C2E86.9000004@oracle.com>
In-Reply-To: <4D1C2E86.9000004@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hugh,

Gurudas Pai wrote:
>>> With 2.6.37-rc8 , run a fio test over nfs, with following jobfile, 
>>> and we
>>> hit kernel bug.
>>
>> Have you tried the same test on earlier releases?
>> I think the bug is old, yet only recently reported.
> I tried with 2.6.36.2 , even there it is panicing.
> 
> 
>> This NFS-triggered kernel BUG at mm/truncate.c:479 sounds very like
>> the FUSE-triggered kernel BUG at mm/truncate.c:475 on 2.6.36.1 for
>> which Miklos posted a patch on 14 December.  Please give his patch
>> (below) a try and let us know if it fixes the issue for you - thanks.
> Issue fixed with the patch, Thanks :)

Is this patch included in mainline ?


>> There's another of these page_mapped truncation BUGs outstanding,
>> that we suspect has a different cause: yours doesn't sound like that
>> one.  I can't explain why three people now in the space of one month
>> should at last hit these ancient bugs!
>>
> 
> 
> Thanks,
> -Guru
> 
