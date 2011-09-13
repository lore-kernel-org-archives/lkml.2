Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609Ab1IMOi1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 10:38:27 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64746 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414Ab1IMOi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 10:38:26 -0400
Message-ID: <4E6F6A89.8020102@gmail.com>
Date: Tue, 13 Sep 2011 17:36:57 +0300
From: Stratos Psomadakis <s.psomadakis@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] Add a personality to report 2.6.x version numbers
References: <1313795710-30827-1-git-send-email-andi@firstfloor.org> <CA+55aFwEgp=3F6uH198XuQR0=6Um-Kp+0Wjcm0Xv1WoHRveKXw@mail.gmail.com> <20110913141158.GA7352@ucw.cz>
In-Reply-To: <20110913141158.GA7352@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2011 05:12 PM, Pavel Machek wrote:
> On Mon 2011-08-22 11:30:33, Linus Torvalds wrote:
>> On Fri, Aug 19, 2011 at 4:15 PM, Andi Kleen <andi@firstfloor.org> wrote:
>>> Reposting due to popular demand. Several other people are running
>>> into the same problem with all kinds of software.
>> I have heard this several times now, but nobody actually ever says
>> *what* is broken.
>>
>> The Fedora people seem to have done the 2.6.40 thing without any
>> actual reason, for example (the two programs they claim were broken
>> were things that they had already fixed in rawhide, afaik).
>>
>> I'm not at all interested in these kinds of "all kinds of software" reports.
>>
>> Details. Examples. Name the f&*cking names already. Shame them publicly.
> ketchup :-(. And no, it is probably not what you wanted, and no, it is
> not easy to fix.
>
ketchup? [1]

Well, I think it doesn't really matter at all, if ketchup broke with 3.x
kernels, but there is a (semi-)working version of ketchup (I'm not very
proud of the code I wrote), which works with 3.x kernels (and
fortunately with 4.x and later).

[1] https://github.com/psomas/ketchup

Thanks,

-- 
Stratos Psomadakis
<psomas@gentoo.org>


-- 
Stratos Psomadakis
<s.psomadakis@gmail.com>

