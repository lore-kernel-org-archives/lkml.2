Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284Ab2GYW63 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 18:58:29 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40968 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab2GYW6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 18:58:25 -0400
Message-ID: <50107A0D.3060003@pobox.com>
Date: Wed, 25 Jul 2012 18:58:21 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates
References: <20120725203551.GA19762@havoc.gtf.org> <20120725204350.GA20530@havoc.gtf.org> <CA+55aFwCCctcmryQJMCT_3TDr60CYBQKu9HMyxOgS8482+w5Xw@mail.gmail.com> <50107297.305@pobox.com> <CA+55aFzun7GebfGZDa73MGLF_808+ROaei5Ag-9HvgUDp1bqLQ@mail.gmail.com>
In-Reply-To: <CA+55aFzun7GebfGZDa73MGLF_808+ROaei5Ag-9HvgUDp1bqLQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2012 06:31 PM, Linus Torvalds wrote:
> On Wed, Jul 25, 2012 at 3:26 PM, Jeff Garzik <jgarzik@pobox.com> wrote:
>>
>> Even so, separately, it still needed that post-merge compile fix.
>
> And that's yet another example of how *NOT* to do things.
>
> If the merge has errors like that, then they should be fixed up in the merge.
>
> Please. Don't do this. Let me merge stuff, and you explain in the pull
> request why it gets merge problems. Not this mess.
>
> That merge itself was *trivial*. I do those kinds of fixups in my
> sleep and you don't even need to explain those. The non-trivial part
> you did as a separate commit. But neither of those should have been
> "I'll pre-merge for Linus so that he doesn't see these problems".

What is the right course in when a post-merge change is needed?

	Jeff





