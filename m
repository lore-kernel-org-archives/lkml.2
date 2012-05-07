Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387Ab2EGSfs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 14:35:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46018 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754707Ab2EGSfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 14:35:47 -0400
Message-ID: <4FA815E3.1030101@zytor.com>
Date: Mon, 07 May 2012 11:35:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Shuah Khan <shuahkhan@gmail.com>,
        mingo@redhat.com, tglx@linutronix.de, tigran@aivazian.fsnet.co.uk,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] x86: kernel/microcode_core.c simple_strtoul cleanup
References: <1336324264.2897.9.camel@lorien2> <20120507104943.GA3896@x1.osrc.amd.com>
In-Reply-To: <20120507104943.GA3896@x1.osrc.amd.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2012 03:49 AM, Borislav Petkov wrote:
> On Sun, May 06, 2012 at 11:11:04AM -0600, Shuah Khan wrote:
>> Change reload_for_cpu() in kernel/microcode_core.c to call kstrtoul()
>> instead of calling obsoleted simple_strtoul().
>>
>> Signed-off-by: Shuah Khan <shuahkhan@gmail.com>
> 
> Ok, much better, thanks.
> 
> @Ingo: I'll pick this one up unless you want to do that :-).
> 

I'll pick it up.  I presume I have your ack on it?

	-hpa

