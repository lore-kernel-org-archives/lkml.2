Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758080Ab2JSTet (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 15:34:49 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:53431 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757133Ab2JSTes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 15:34:48 -0400
MIME-Version: 1.0
X-Originating-IP: [91.205.155.63]
In-Reply-To: <20121019191944.GA27699@alpha.arachsys.com>
References: <1350235151-11146-1-git-send-email-dmitry@daynix.com>
	<1350235151-11146-2-git-send-email-dmitry@daynix.com>
	<1350280341.2152.12.camel@jtkirshe-mobl>
	<20121019191944.GA27699@alpha.arachsys.com>
Date: Fri, 19 Oct 2012 21:34:47 +0200
Message-ID: <CAGHCxheg1eWHEipfArACSCHyB59H0k+3o4ZpMKxUKZXgBAZSuw@mail.gmail.com>
Subject: Re: [E1000-devel] [PATCH] RX initialization sequence fixed - enable
 RX after corresponding ring initialization only
From: Dmitry Fleytman <dmitry@daynix.com>
To: Richard Davies <richard.davies@elastichosts.com>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>, linux-kernel@vger.kernel.org,
        e1000-devel@lists.sourceforge.net,
        Chris Webb <chris.webb@elastichosts.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exactly. This patch is incorrect and should be ignored.

Dmitry.

On Fri, Oct 19, 2012 at 9:19 PM, Richard Davies
<richard.davies@elastichosts.com> wrote:
> Jeff Kirsher wrote:
>> Dmitry Fleytman wrote:
>> > Reported-by: Chris Webb <chris.webb@elastichosts.com>
>> > Reported-by: Richard Davies <richard.davies@elastichosts.com>
>> >
>> > Signed-off-by: Dmitry Fleytman <dmitry@daynix.com>
>> > ---
>> >  drivers/net/ethernet/intel/e1000/e1000_ethtool.c |    9 +++++----
>> >  drivers/net/ethernet/intel/e1000/e1000_main.c    |   18
>> > ++++++++++++++++--
>> >  2 files changed, 21 insertions(+), 6 deletions(-)
>>
>> I will add it to my queue.  Thanks!
>
> Hi Jeff,
>
> I hope it was already clear from the following discussion - this patch
> turned out to be a qemu-kvm bug and you do not need to apply it.
>
> Dmitry - please confirm.
>
> Richard.



-- 
Dmitry Fleytman
Technology Expert and Consultant,

Daynix Computing Ltd.

Cell: +972-54-2819481

Skype: dmitry.fleytman
