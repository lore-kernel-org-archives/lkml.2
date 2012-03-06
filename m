Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030952Ab2CFUIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 15:08:00 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49880 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030800Ab2CFUH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 15:07:58 -0500
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20120306200111.GM29367@moon>
References: <1330518197-12825-1-git-send-email-gorcunov@openvz.org>
 <1330518197-12825-2-git-send-email-gorcunov@openvz.org> <CAKgNAkiOY-p7duD_wfed_Tk8T8SR5r1JCTa=0ne3-VQ30mQE-g@mail.gmail.com>
 <20120306182210.GJ29367@moon> <CAKgNAkjejoxs43UVgAR+YW7JZ1btCpMr+=K4jrZz=Ktv-TnS8w@mail.gmail.com>
 <20120306200111.GM29367@moon>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Wed, 7 Mar 2012 09:07:38 +1300
Message-ID: <CAKgNAkg1Mhwcs_-LroUCF57e2GKDHPKsJRYKt5QW=Z1tGA8Ojw@mail.gmail.com>
Subject: Re: [PATCH 1/2] prctl: Add PR_SET_MM option description
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>, linux-man@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 7, 2012 at 9:01 AM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> On Wed, Mar 07, 2012 at 08:52:30AM +1300, Michael Kerrisk (man-pages) wrote:
> ...
>> >
>> > If you prefer to have it done earlier -- no problem, I'll cook
>> > a patch today instead on top of everything we've already
>> > merged into linux-next. What would you prefer?
>>
>> It would make sense if the capability requirements were finalized
>> before 3.3 is released. Changing them after 3.3 creates (at least a
>> little) pain for userspace.
>>
>
> OK. I'll update and send a patch out.

Take a look at http://man7.org/linux/man-pages/man7/capabilities.7.html

The two most obvious alternatives are CAP_SYS_RESOURCE and
CAP_SYS_NICE. Maybe CAP_SYS_NICE is better? I say this because of the
(slight) similarity to existing operations in the CAP_SYS_NICE list.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
