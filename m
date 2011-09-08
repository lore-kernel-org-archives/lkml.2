Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932497Ab1IHIyc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 04:54:32 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:58141 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932384Ab1IHIya convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 04:54:30 -0400
MIME-Version: 1.0
In-Reply-To: <1315382451.11101.12.camel@twins>
References: <CAC9WiBiNj-NS2mb8SaR1pK2JQdJOAbnN_rCXk1ZEMNaWQWZwxQ@mail.gmail.com>
	<1315382451.11101.12.camel@twins>
Date: Thu, 8 Sep 2011 10:54:29 +0200
Message-ID: <CAC9WiBj0D7-yG8DADRVAphhuCPHbxfh8Cp6Adh-G90gOt_h-RA@mail.gmail.com>
Subject: Re: v3.1-rc5: Weird kernel log message when resuming avout NMI received
From: Francis Moreau <francis.moro@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Don Zickus <dzickus@redhat.com>, Stephane Eranian <eranian@google.com>,
        Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 7, 2011 at 10:00 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Wed, 2011-09-07 at 08:37 +0200, Francis Moreau wrote:
>>
>> > After the second suspend/resume sequence I still have the same warning
>> > except that the reason has changed to '2d':
>> >
>> >  kernel:[  404.091393] Uhhuh. NMI received for unknown reason 2d on CPU 0.
>> >  kernel:[  404.091394] Do you have a strange power saving mode enabled?
>> >  kernel:[  404.091396] Dazed and confused, but trying to continue
>
> I'm somewhat out of ideas there..  I guess I'll have to go debug on my
> laptop which hasn't got a serial port :-(

Do you hit the same issue ?

If I can help in anything just tell me :)

-- 
Francis
