Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932978Ab1AMVzk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 16:55:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932498Ab1AMVzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 16:55:33 -0500
Message-ID: <4D2F74B0.6030206@redhat.com>
Date: Thu, 13 Jan 2011 22:54:56 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101213 Thunderbird/3.1.7
MIME-Version: 1.0
To: Alasdair G Kergon <agk@redhat.com>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] core block bits for 2.6.38
References: <4D2F03A7.2030809@fusionio.com> <20110113192152.GA18217@agk-dp.fab.redhat.com> <AANLkTin8icx0cir8czy9snZ0wg=QovJ4HSZru4jYUoea@mail.gmail.com> <4D2F5353.3000400@fusionio.com> <AANLkTi=VaaJr1b37yabEj-XTe1pRzcEg6OHLb1HbEES0@mail.gmail.com> <20110113214308.GA18104@agk-dp.fab.redhat.com>
In-Reply-To: <20110113214308.GA18104@agk-dp.fab.redhat.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 01/13/2011 10:43 PM, Alasdair G Kergon wrote:
> On Thu, Jan 13, 2011 at 09:05:40PM +0100, Tejun Heo wrote:
>> On Thu, Jan 13, 2011 at 8:32 PM, Jens Axboe <jaxboe@fusionio.com> wrote:
>>> I see Tejun already posted a fix, but Milan says it does not work.
>>> Tejun, any  updates?
>>
>> Hmmm... seems like I missed something.  Unfortunately, it's already a
>> bit too late here.  I'll get back to it tomorrow afternoon.  The issue
>> is mostly cosmetic so if it can wait a day or two I don't think
>> reverting is necessary.
>  
> It's only cosmetic if your system is not relying upon userspace programs
> that rely upon it:)   My vote would be for reverting the patch for now
> so we can be sure the existing userspace functionality continues to work
> in -rc1.

It is not cosmetic, it breaks core lvm functionality, see my lvresize test case
in the reporting thread. Sorry, but this should be fixed soon or reverted...
http://article.gmane.org/gmane.linux.raid/31164

I thought it is just warning but when testing the fix it shows that
the problem is worse than warning.

Milan

