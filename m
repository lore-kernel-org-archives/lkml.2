Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab1DMRjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 13:39:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36225 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868Ab1DMRjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 13:39:08 -0400
Message-ID: <4DA5DF89.5040302@zytor.com>
Date: Wed, 13 Apr 2011 10:38:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110403 Fedora/3.1.9-6.fc15 Thunderbird/3.1.9
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Frank Arnold <farnold@amd64.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Clean up mwait_play_dead
References: <1302711073-31985-1-git-send-email-farnold@amd64.org> <4DA5D4D8.7000902@zytor.com> <20110413173634.GA1904@gere.osrc.amd.com>
In-Reply-To: <20110413173634.GA1904@gere.osrc.amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2011 10:36 AM, Borislav Petkov wrote:
>>
>> This should be using this_cpu_has()... if that's not in the tree yet we
>> should add it.
> 
> Looks like it is still in tip/x86/mm.
> 
> We could either redo the patch properly when this_cpu_has() is merged or
> add the change against that branch.
> 

It really should probably have been in tip:x86/cpu not x86/mm, but since
this is so simple we can just add it to the branch.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

