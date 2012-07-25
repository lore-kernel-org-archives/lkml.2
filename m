Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab2GYW0h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 18:26:37 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54130 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab2GYW0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 18:26:35 -0400
Message-ID: <50107297.305@pobox.com>
Date: Wed, 25 Jul 2012 18:26:31 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates
References: <20120725203551.GA19762@havoc.gtf.org> <20120725204350.GA20530@havoc.gtf.org> <CA+55aFwCCctcmryQJMCT_3TDr60CYBQKu9HMyxOgS8482+w5Xw@mail.gmail.com>
In-Reply-To: <CA+55aFwCCctcmryQJMCT_3TDr60CYBQKu9HMyxOgS8482+w5Xw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2012 06:06 PM, Linus Torvalds wrote:
> On Wed, Jul 25, 2012 at 1:43 PM, Jeff Garzik <jeff@garzik.org> wrote:
>> On Wed, Jul 25, 2012 at 04:35:51PM -0400, Jeff Garzik wrote:
>>> Please pull 641589bff714f39b33ef1d7f02eaa009f2993b64 from
>>> git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git tags/upstream
>>>
>>
>> Oh, I forgot to point out the merge commit, making my HEAD more recent
>> than might be expected.  There was a merge conflict and an API change
>> that needed to be dealt with, in order for your pull to be correct.
>
> So I'd *much* rather see an explanation of what the conflict is when
> you ask me to pull, and let me handle it, rather than you pre-merging
> things for me. I *want* to see conflicts between subsystems.
> Seriously.

Tried to add some explanation to the merge commit itself, giving plenty 
of detail.

Even so, separately, it still needed that post-merge compile fix.

	Jeff



