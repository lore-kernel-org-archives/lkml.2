Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978Ab1CBW74 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 17:59:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59228 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755602Ab1CBW7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 17:59:55 -0500
Message-ID: <4D6ECBDB.6090307@zytor.com>
Date: Wed, 02 Mar 2011 14:59:39 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: RFC: x86: kill binutils 2.16.x?
References: <4D6E8932.1010405@zytor.com> <alpine.LFD.2.00.1103022152420.2701@localhost6.localdomain6> <4D6EB07C.5040004@zytor.com> <alpine.LFD.2.00.1103022216180.2701@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1103022216180.2701@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2011 01:17 PM, Thomas Gleixner wrote:
> On Wed, 2 Mar 2011, H. Peter Anvin wrote:
> 
>> On 03/02/2011 12:54 PM, Thomas Gleixner wrote:
>>>
>>> Please lets get rid of known to be broken shite instead of trying to
>>> work around it for no good reasons. How old is that crap again ?
>>>
>>
>> 2005-2006.
> 
> Time enough even for enterprise folks to sort that out. Please kill it
> ASAP.
> 
> Thanks,
> 

kbuild people: is there a way to test for a specific assembler version
in Kbuild (and error out the build for it?)

	-hpa
