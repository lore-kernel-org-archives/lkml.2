Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab2KMMLz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 07:11:55 -0500
Received: from multi.imgtec.com ([194.200.65.239]:52741 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749Ab2KMMLx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 07:11:53 -0500
Message-ID: <50A23906.6010900@imgtec.com>
Date: Tue, 13 Nov 2012 12:11:50 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Jonas Bonn <jonas.bonn@gmail.com>
CC: Arnd Bergmann <arnd@arndb.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tglx@linutronix.de>, Markos <markos.chandras@imgtec.com>
Subject: Re: [RFC PATCH v1 14/31] ARC: syscall support
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com> <1352281674-2186-15-git-send-email-vgupta@synopsys.com> <201211071421.39523.arnd@arndb.de> <509CD1D1.3050105@imgtec.com> <50A231EE.7050204@imgtec.com> <CACM3HyFE-S2NM75qVS2Fhhm8YoP1jH4mS41aZ5B1gW2wo-Q99g@mail.gmail.com>
In-Reply-To: <CACM3HyFE-S2NM75qVS2Fhhm8YoP1jH4mS41aZ5B1gW2wo-Q99g@mail.gmail.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2012_11_13_12_11_51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/11/12 12:01, Jonas Bonn wrote:
> On 13 November 2012 12:41, James Hogan <james.hogan@imgtec.com> wrote:
>> The uClibc patches I mentioned have been posted, see here:
>>
>> http://lists.busybox.net/pipermail/uclibc/2012-November/047110.html
>>
>> Please do try them out and provide any feedback.
>>
> 
> Hi James,
> 
> Many thanks for picking this up...
> 
> This is the third time around for trying to get this into uClibc as
> Mark Salter also pushed a patch set which got about as much feedback
> (almost none) on the list as mine did.  His patchset, like yours,
> preferred the "old" syscalls when present.
> 
> ...and that gets me around to the question:  why should the "old"
> syscalls be preferred?  I'm specifically asking this here because I'm
> curious what the kernel developers' take on this is.

Hi Jonas,

Hopefully with several architecture maintainers asking for this it might
get somewhere, but indeed we're aware of the feedback problem on that list.

The points that I've considered for defaulting to old syscalls:
* doesn't change existing behaviour of other architectures, so is simply
less risk of breaking them.
* could possibly make uClibc slightly smaller if it doesn't have to add
extra arguments.

against:
* if defaulted to new syscalls, could give customers a chance to rebuild
their libc so that when deprecated syscalls are removed they don't notice.

Cheers
James

