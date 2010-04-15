Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555Ab0DOIuX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 04:50:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62805 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757513Ab0DOIuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 04:50:21 -0400
Message-ID: <4BC6D334.8050607@redhat.com>
Date: Thu, 15 Apr 2010 11:49:56 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, Ralf Baechle <ralf@linux-mips.org>,
       mingo@elte.hu, tglx@linutronix.de, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] X86: Optimise fls(), ffs() and fls64()
References: <4BC5D19A.8000605@redhat.com> <20100406133026.GD20577@parisc-linux.org> <alpine.LFD.2.00.1003261005490.3721@i5.linux-foundation.org> <20100326144241.8583.95617.stgit@warthog.procyon.org.uk> <28287.1269625325@redhat.com> <alpine.LFD.2.00.1003261042580.3721@i5.linux-foundation.org> <20100326175827.GD20055@linux-mips.org> <alpine.LFD.2.00.1003261100440.3721@i5.linux-foundation.org> <17213.1271245760@redhat.com> <3879.1271321292@redhat.com>
In-Reply-To: <3879.1271321292@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2010 11:48 AM, David Howells wrote:
> Avi Kivity<avi@redhat.com>  wrote:
>
>    
>> Even if Intel processors behave that way, other processors (real and
>> emulated) use those manuals as a specification.  Emulated processors are
>> unlikely to touch an undefined register, but real processors may.
>>
>> (qemu tcg appears not to touch the output)
>>      
> Possibly because the AMD64 spec specifies that the destination will be
> unchanged if the source was 0.
>    

Likely.  But we haven't tested all current and future x86 clones, and 
they may be based off the Intel documentation instead of the AMD 
documentation.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

