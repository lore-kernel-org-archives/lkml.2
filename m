Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227Ab2KMQYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 11:24:53 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:50911 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755042Ab2KMQYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 11:24:51 -0500
MIME-Version: 1.0
In-Reply-To: <509D5C97.2020801@oracle.com>
References: <50899507.1040900@oracle.com> <20121026143754.50277bd8@pyramind.ukuu.org.uk>
 <CA+1xoqdEesjh1EZvR_r7Hn0GUc7741EDWn59qagngcxg4=9bjQ@mail.gmail.com>
 <20121105175937.26f31d2a@pyramind.ukuu.org.uk> <5097FEA9.2090603@oracle.com>
 <alpine.LNX.2.00.1211051106590.1709@eggly.anvils> <20121105201507.79fe47d7@pyramind.ukuu.org.uk>
 <alpine.LNX.2.00.1211051231070.21645@eggly.anvils> <20121106161100.216c6d79@pyramind.ukuu.org.uk>
 <20121106164214.GA18246@redhat.com> <20121106173845.4a50d661@pyramind.ukuu.org.uk>
 <509A665C.3030603@gmail.com> <20121107160232.18e83ee9@pyramind.ukuu.org.uk>
 <87625h9yoe.fsf@nemi.mork.no> <20121108143408.77033416@pyramind.ukuu.org.uk>
 <alpine.LNX.2.00.1211091133310.3733@eggly.anvils> <509D5C97.2020801@oracle.com>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Tue, 13 Nov 2012 11:24:29 -0500
Message-ID: <CA+1xoqeZ7ByntzpaWKkphJNOJqMzBLvufSvKwe7mS-2sMyVSBg@mail.gmail.com>
Subject: Re: tty, vt: lockdep warnings (Patch v3)
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Hugh Dickins <hughd@google.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        =?ISO-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>,
        Dave Jones <davej@redhat.com>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, florianSchandinat@gmx.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 9, 2012 at 2:42 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
> On 11/09/2012 02:34 PM, Hugh Dickins wrote:
>> On Thu, 8 Nov 2012, Alan Cox wrote:
>>> commit f35b3fbf24c4e4debb6a7a864b09854ccc2a22e7
>>> Author: Alan Cox <alan@linux.intel.com>
>>> Date:   Wed Nov 7 16:35:08 2012 +0000
>>>
>>>     fb: Rework locking to fix lock ordering on takeover
>>>
>>>     Adjust the console layer to allow a take over call where the caller already
>>>     holds the locks. Make the fb layer lock in order.
>>>
>>>     This s partly a band aid, the fb layer is terminally confused about the
>>>     locking rules it uses for its notifiers it seems.
>>>
>>>     Signed-off-by: Alan Cox <alan@linux.intel.com>
>>
>> This version works for me too - thanks.
>> Hugh
>
> I was planning to test it last night, but new code in mm/ failed horribly and
> was BUG()ing all over the place, so I didn't get any significant testing
> of this patch done.
>
> Will update...

Nothing complains anywhere, looks great.


Thanks,
Sasha
