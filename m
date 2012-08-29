Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881Ab2H2Efh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 00:35:37 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41994 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab2H2Eff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 00:35:35 -0400
Date: Wed, 29 Aug 2012 06:35:30 +0200 (CEST)
From: Peter Osterlund <peterosterlund2@gmail.com>
X-X-Sender: petero@acer.localdomain
To: Jiri Kosina <jkosina@suse.cz>
cc: Tejun Heo <tj@kernel.org>, Kent Overstreet <koverstreet@google.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, vgoyal@redhat.com, mpatocka@redhat.com,
        bharrosh@panasas.com
Subject: Re: [PATCH v6 04/13] pktcdvd: Switch to bio_kmalloc()
In-Reply-To: <alpine.LNX.2.00.1208281608560.22447@pobox.suse.cz>
Message-ID: <alpine.LFD.2.02.1208290634360.15468@acer.localdomain>
References: <1345655050-28199-1-git-send-email-koverstreet@google.com> <1345655050-28199-5-git-send-email-koverstreet@google.com> <20120822195546.GG19212@google.com> <alpine.LNX.2.00.1208281608560.22447@pobox.suse.cz>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Aug 2012, Jiri Kosina wrote:

> On Wed, 22 Aug 2012, Tejun Heo wrote:
>
>> (cc'ing Jiri, hi!)
>
> Hi there! :)
>
>> On Wed, Aug 22, 2012 at 10:04:01AM -0700, Kent Overstreet wrote:
>>> This is prep work for killing bi_destructor - previously, pktcdvd had
>>> its own pkt_bio_alloc which was basically duplication bio_kmalloc(),
>>> necessitating its own bi_destructor implementation.
>>>
>>> v5: Un-reorder some functions, to make the patch easier to review
>>>
>>> Signed-off-by: Kent Overstreet <koverstreet@google.com>
>>> CC: Peter Osterlund <petero2@telia.com>
>>
>> Apart from bio_reset() not resetting bi_end_io and bi_private, this
>> looks fine to me but lack of testing makes me a bit hesitant to ack
>> it.
>>
>> Peter doesn't want to be the maintainer of pktcdvd anymore.  Maybe
>> Jiri can be tricked into taking this one too?  :)
>
> Gah, seems like the floppy saga is going to cause me some more trouble in
> the future ... :)
>
> Well, I definitely have hardware back at home that supports this, so I can
> take it. Doesn't seem to be heavy traffic code either.
>
> Peter, ok with that? Also, how was this usually fed upstream -- through
> Jens' tree?

Yes, I am ok with that.

-- 
Peter Osterlund - peterosterlund2@gmail.com, petero2@comhem.se
http://web.comhem.se/petero2home
