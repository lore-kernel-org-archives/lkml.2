Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab2DTQuF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 12:50:05 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42056 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593Ab2DTQuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 12:50:03 -0400
Message-ID: <4F9193B7.7060706@gmail.com>
Date: Fri, 20 Apr 2012 09:49:59 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: David Daney <ddaney.cavm@gmail.com>, Ralf Baechle <ralf@linux-mips.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v1 1/5] scripts: Add sortextable to sort the kernel's
 exception table.
References: <1334872799-14589-1-git-send-email-ddaney.cavm@gmail.com> <1334872799-14589-2-git-send-email-ddaney.cavm@gmail.com> <20120420145920.GA2891@merkur.ravnborg.org>
In-Reply-To: <20120420145920.GA2891@merkur.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/2012 07:59 AM, Sam Ravnborg wrote:
> On Thu, Apr 19, 2012 at 02:59:55PM -0700, David Daney wrote:
>> From: David Daney<david.daney@cavium.com>
>>
>> Using this build-time sort saves time booting as we don't have to burn
>> cycles sorting the exception table.
>>
>> Signed-off-by: David Daney<david.daney@cavium.com>
>> ---
>>   scripts/.gitignore    |    1 +
>>   scripts/Makefile      |    1 +
>>   scripts/sortextable.c |  273 +++++++++++++++++++++++++++++++++++++++++++++++++
>>   scripts/sortextable.h |  168 ++++++++++++++++++++++++++++++
>
> If there is only a single file including the .h file - then there is no gain.
> Just fold it into the .c file.
>

s/single file/single site/, and I am in complete agreement.  However 
this patch doesn't meet that criterion.  In this particular case, there 
is more to the patch than just the diffstat.

David Daney
