Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075Ab1LGC5X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 21:57:23 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:51833 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955Ab1LGC5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 21:57:21 -0500
MIME-Version: 1.0
In-Reply-To: <20111206163810.24663e3f@tlielax.poochiereds.net>
References: <4ED56C12.1040708@gmail.com>
	<4ED5C047.6040500@linux.vnet.ibm.com>
	<20111130062502.68d9db59@tlielax.poochiereds.net>
	<201112062233.50317.rjw@sisk.pl>
	<20111206163810.24663e3f@tlielax.poochiereds.net>
Date: Tue, 6 Dec 2011 20:57:20 -0600
Message-ID: <CAH2r5muxd786KGGscEGmTHTMbf9vjN-OPzwcHSNftf_vFWtNvg@mail.gmail.com>
Subject: Re: CIFS mount: 3.2.0-rc3 suspend crash
From: Steve French <smfrench@gmail.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Woody Suwalski <terraluna977@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Belisko Marek <marek.belisko@gmail.com>,
        linux-cifs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 6, 2011 at 3:38 PM, Jeff Layton <jlayton@redhat.com> wrote:
> On Tue, 6 Dec 2011 22:33:50 +0100
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
>
>> On Wednesday, November 30, 2011, Jeff Layton wrote:
>> > On Wed, 30 Nov 2011 11:03:59 +0530
>> > "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>>
>> [...]
>> >
>> > cifs: attempt to freeze while looping on a receive attempt
>> >
>> > In the recent overhaul of the demultiplex thread receive path, we
>> > neglected to ensure that we attempt to freeze on each pass through the
>> > loop.
>> >
>> > Reported-by: Woody Suwalski <terraluna977@gmail.com>
>> > Signed-off-by: Jeff Layton <jlayton@redhat.com>
>>
>> I suppose this patch is going to go through the CIFS tree?
>>
>
> Yes, Steve said he would push it Linus...

Yes.  I wanted to run a few general tests against the current cifs
tree first though.


-- 
Thanks,

Steve
