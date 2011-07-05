Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402Ab1GENbn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 09:31:43 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39790 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab1GENbl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 09:31:41 -0400
MIME-Version: 1.0
In-Reply-To: <20110705105330.63c113c8@endymion.delvare>
References: <20110627185505.19423.64214.stgit@ponder> <BANLkTi=6zxPUwGZ5JHhRGRHHaEgvNgiaHQ@mail.gmail.com>
 <20110705105330.63c113c8@endymion.delvare>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 5 Jul 2011 07:31:20 -0600
X-Google-Sender-Auth: OZNbMsIbsmKuljhwEAJjdTFS_bQ
Message-ID: <CACxGe6uDSS3eeah=+LO+u9ZV=pCjDLy2nYC3J_a8m-=QRgEeWw@mail.gmail.com>
Subject: Re: [PATCH] i2c: Allow i2c_add_numbered_adapter() to assign a bus id.
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-i2c@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        linux-kernel@vger.kernel.org,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Bonesio <bones@secretlab.ca>, Stephen Warren <SWarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 5, 2011 at 2:53 AM, Jean Delvare <khali@linux-fr.org> wrote:
> Hi Grant,
>
> Sorry for the late answer.
>
> On Mon, 27 Jun 2011 13:02:45 -0600, Grant Likely wrote:
>> On Mon, Jun 27, 2011 at 12:55 PM, Grant Likely
>> <grant.likely@secretlab.ca> wrote:
>> > Currently, if an i2c bus driver supports both static and dynamic bus
>> > ids, it needs to choose between calling i2c_add_numbered_adapter() and
>> > i2c_add_adapter().  This patch makes i2c_add_numbered_adapter()
>> > redirect to i2c_add_adapter() if the requested bus id is -1.
>> >
>> > Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
>>
>> Oops, forgot to edit the email before sending the patch.
>>
>> This patch is as-yet untested other than build testing, but I want to
>> get feedback.  With the move to DT on ARM, there are going to be a lot
>> more i2c bus drivers that need to support both static and dynamically
>> allocated busses, and it is very likely that it will be needed in the
>> v3.1 merge window.
>>
>> Ben/Jean, *IF* this patch tests out okay, and *IF* I get an ack from
>> you, it will probably need to have this commit in my devicetree/next
>> branch.  If so, then I'll either need to commit it myself, or have it
>> put into a separate topic branch that both of us can merge into our
>> trees.  What is your preference.
>>
>> John: this is the patch that I asked you to write earlier today, but I
>> think one of the TI folks will run into the same issue, so I wanted to
>> get it drafted and onto the list ASAP.
>
> If this makes your life easier then I have no objection, you can go
> ahead. I don't expect any conflict with my tree as there is no i2c-core
> work going on on my end at the moment. So you can just take it in your
> tree and merge it yourself as you see fit.
>
> Acked-by: Jean Delvare <khali@linux-fr.org>

Thanks Jean, will do.

g.
