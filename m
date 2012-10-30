Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964857Ab2J3Q0N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 12:26:13 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:39950 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964816Ab2J3Q0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 12:26:10 -0400
MIME-Version: 1.0
In-Reply-To: <20121030152925.GA7023@redhat.com>
References: <1340742778-11282-1-git-send-email-fes@google.com>
 <20120910090521.GB18544@redhat.com> <CAGTjWtBa5jW6+y1k6zZmD9TUNHBgv8WRbO_iy7huY_dJSumStw@mail.gmail.com>
 <20120910195931.GD20721@redhat.com> <CAGTjWtCiqjkR_Ze=0-ebO08+eziz6c8TXLb+O1iiArRQeSE6zw@mail.gmail.com>
 <20120910211018.GB21484@redhat.com> <20121030152925.GA7023@redhat.com>
From: Mike Waychison <mikew@google.com>
Date: Tue, 30 Oct 2012 09:25:49 -0700
Message-ID: <CAGTjWtAyoqDS9vAc1HShBLfsdfuBy4-Aev+_Rn-f0H2V2C1PTg@mail.gmail.com>
Subject: Re: [PATCH] Add a page cache-backed balloon device driver.
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Frank Swiderski <fes@google.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        virtualization@lists.linux-foundation.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2012 at 8:29 AM, Michael S. Tsirkin <mst@redhat.com> wrote:
> On Tue, Sep 11, 2012 at 12:10:18AM +0300, Michael S. Tsirkin wrote:
>> > On the plus side, having an exit taken here on each page turns out to
>> > be relatively cheap, as the vmexit from the page fault should be
>> > faster to process as it is fully handled within the host kernel.
>> >
>> > Perhaps some combination of both methods is required? I'm not sure :\
>>
>> Perhaps some benchmarking is in order :)
>> Can you try telling host, potentially MADV_WILL_NEED
>> in that case like qemu does, then run your proprietary test
>> and see if things work well enough?
>
> Ping. Had a chance to try that?

Not yet.  We've been focused on other things recently and probably
won't have a chance to return to this for a couple months at best.
Sorry :(
