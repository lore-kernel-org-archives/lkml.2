Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224Ab1HRRPo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 13:15:44 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56492 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab1HRRPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 13:15:43 -0400
MIME-Version: 1.0
In-Reply-To: <20110818130408.71c55b96@barsoom.rdu.redhat.com>
References: <alpine.DEB.2.02.1108150506310.7571@p34.internal.lan>
	<alpine.LNX.2.00.1108151117480.19668@swampdragon.chaosbits.net>
	<20110815064734.403b630f@corrin.poochiereds.net>
	<alpine.DEB.2.02.1108150653200.7571@p34.internal.lan>
	<alpine.DEB.2.02.1108151357200.32349@p34.internal.lan>
	<alpine.DEB.2.02.1108171515050.5877@p34.internal.lan>
	<3300.1313637592@jrobl>
	<alpine.DEB.2.02.1108180632000.10458@p34.internal.lan>
	<alpine.DEB.2.02.1108180807070.7903@p34.internal.lan>
	<alpine.DEB.2.02.1108180821440.7903@p34.internal.lan>
	<20110818091140.385a9455@barsoom.rdu.redhat.com>
	<alpine.DEB.2.02.1108180914180.7903@p34.internal.lan>
	<20110818130408.71c55b96@barsoom.rdu.redhat.com>
Date: Thu, 18 Aug 2011 12:15:42 -0500
Message-ID: <CAH2r5msF-A-TAc1+MiGaf6=FCsky1QNi+A8bg8T6wkQ-WFrxGQ@mail.gmail.com>
Subject: Re: Kernel 3.0: Instant kernel crash when mounting CIFS (also crashes
 with linux-3.1-rc2
From: Steve French <smfrench@gmail.com>
To: Jeff Layton <jlayton@samba.org>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>,
        "J. R. Okajima" <hooanon05@yahoo.co.jp>,
        Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
        Alan Piszcz <ap@solarrain.com>, Steve French <sfrench@samba.org>,
        linux-cifs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 18, 2011 at 12:04 PM, Jeff Layton <jlayton@samba.org> wrote:
> On Thu, 18 Aug 2011 09:15:36 -0400 (EDT)
> Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>> [ 3882.026917] CIFS VFS: did not end path lookup where expected namelen is 0
>>
>> Justin.
>>
>
> I've sent a patch to Steve to turn those printk's into debug messages
> for 3.1 and it should make its way there soon. It should be safe to
> ignore them in the meantime.
>
> In fact, that patch should probably go to 3.0-stable as well. Steve can
> you add the 'Cc: stable@kernel.org' line to that patch?

Already done.

-- 
Thanks,

Steve
