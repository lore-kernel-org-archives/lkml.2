Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446Ab2HKFYw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 01:24:52 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:52988 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab2HKFYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 01:24:46 -0400
MIME-Version: 1.0
X-Originating-IP: [121.44.126.22]
In-Reply-To: <20120808235731.GA7262@moria.home.lan>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
	<1344290921-25154-3-git-send-email-koverstreet@google.com>
	<20120808220612.GA6983@dhcp-172-17-108-109.mtv.corp.google.com>
	<20120808235731.GA7262@moria.home.lan>
Date: Sat, 11 Aug 2012 15:24:45 +1000
Message-ID: <CAOzFzEhPW5-edb6mnL2gNbb4956u2MbWqQovv01010PyBCbc+g@mail.gmail.com>
Subject: Re: [PATCH v5 02/12] dm: Use bioset's front_pad for dm_rq_clone_bio_info
From: Joseph Glanville <joseph.glanville@orionvm.com.au>
To: Kent Overstreet <koverstreet@google.com>
Cc: Tejun Heo <tj@kernel.org>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, axboe@kernel.dk,
        agk@redhat.com, neilb@suse.de, drbd-dev@lists.linbit.com,
        vgoyal@redhat.com, mpatocka@redhat.com, sage@newdream.net,
        yehuda@hq.newdream.net, snitzer@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kent, Tejun

On 9 August 2012 09:57, Kent Overstreet <koverstreet@google.com> wrote:
>> Also, how was this tested?
>
> Well, AFAICT the only request based dm target is multipath, and from the
> documentation I've seen it doesn't appear to work without multipath
> hardware, or at least I haven't seen it documented how. So, unless
> there's another user I missed it's not been tested.

Multipath can be tested quite easily with a loopback scsi target, you
don't require specialized hardware.
The easiest way to do this would probably be the built in LIO target +
open_iscsi initiator.

I haven't attempted running this current version of the patch series
but I haven't run into issues with bcache+multipath in the past.

>
>>
>> Thanks.
>>
>> --
>> tejun
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
CTO | Orion Virtualisation Solutions | www.orionvm.com.au
Phone: 1300 56 99 52 | Mobile: 0428 754 846
