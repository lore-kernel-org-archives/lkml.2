Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237Ab1GNUkX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 16:40:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39326 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932075Ab1GNUkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 16:40:22 -0400
Message-ID: <4E1F5429.6080903@zytor.com>
Date: Thu, 14 Jul 2011 13:40:09 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Mike Waychison <mikew@google.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: Allow disabling of sys_iopl, sys_ioperm
References: <1310675693-9204-1-git-send-email-mikew@google.com> <1310675693-9204-2-git-send-email-mikew@google.com> <4E1F5380.9020709@zytor.com> <CAGTjWtD8Obn0LsXr+Dq7xqQEYnY4UV7CAiO2+L2LLpv_1s_ufw@mail.gmail.com>
In-Reply-To: <CAGTjWtD8Obn0LsXr+Dq7xqQEYnY4UV7CAiO2+L2LLpv_1s_ufw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2011 01:38 PM, Mike Waychison wrote:
>>
>> Wouldn't it be more useful for this to be a sysctl?  In particular, like
>> many similar things it probably should be a lockable sysctl (three
>> states: enabled, disabled, and locked-disabled).
>>
>> Making it a compile-time option I'm very skeptical to.
> 
> Are there existing examples of this already in the tree?
> 

I think so, but I don't know off the top of my head.

	-hpa
