Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab2HIGaJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 02:30:09 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:32927 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027Ab2HIGaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 02:30:07 -0400
MIME-Version: 1.0
In-Reply-To: <20120809060640.GA9088@dhcp-172-18-216-138.mtv.corp.google.com>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
	<1344290921-25154-4-git-send-email-koverstreet@google.com>
	<20120808221129.GB6983@dhcp-172-17-108-109.mtv.corp.google.com>
	<20120809000711.GB7262@moria.home.lan>
	<20120809060019.GA2845@dhcp-172-17-108-109.mtv.corp.google.com>
	<20120809060640.GA9088@dhcp-172-18-216-138.mtv.corp.google.com>
Date: Wed, 8 Aug 2012 23:30:05 -0700
X-Google-Sender-Auth: fSe20D0na56F2r6o0yK9hrOwulI
Message-ID: <CAOS58YOMRF9fssZV8nR1kB+o7qFsti8Kc43pCaX_aekt7sEwYA@mail.gmail.com>
Subject: Re: [PATCH v5 03/12] block: Add bio_reset()
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, agk@redhat.com, neilb@suse.de,
        drbd-dev@lists.linbit.com, vgoyal@redhat.com, mpatocka@redhat.com,
        sage@newdream.net, yehuda@hq.newdream.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Aug 8, 2012 at 11:06 PM, Kent Overstreet <koverstreet@google.com> wrote:
> On Wed, Aug 08, 2012 at 11:00:19PM -0700, Tejun Heo wrote:
>> Anyways, understood.  Can you *please* put some comment what bits are
>> being preserved across reset then?  Things like this aren't obvious at
>> all and need ample explanation.
>
> I did, in the header:
>
> #define BIO_RESET_BITS  12      /* Flags starting here get preserved by
> bio_reset() */
>
> Where the rest of the flags are defined, and near where BIO_RESET_BYTES
> are defined.

Yeah, I was hoping for the comment to note that the protected bits
include the pool index.

Thanks.

-- 
tejun
