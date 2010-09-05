Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617Ab0IEQLe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 12:11:34 -0400
Received: from freeflow.nu ([178.79.134.28]:37116 "EHLO freeflow.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753153Ab0IEQLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 12:11:33 -0400
Message-ID: <4C83C124.8050408@kernel.org>
Date: Sun, 05 Sep 2010 19:11:16 +0300
From: Pekka Enberg <penberg@kernel.org>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.4; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Sven Joachim <svenjoac@gmx.de>
CC: Hugh Dickins <hughd@google.com>, Chris Wilson <chris@chris-wilson.co.uk>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Sitsofe Wheeler <sitsofe@yahoo.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] Revert "drm/i915: fix vblank wait test condition"
References: <1283588234-2514-1-git-send-email-penberg@kernel.org>	<89k83a$9hv9li@azsmga001.ch.intel.com>	<AANLkTi=_OW5NvnS1oWzt3DW9CPPwNX_sAkPh_QOuXzhv@mail.gmail.com>	<alpine.LSU.2.00.1009041244440.3044@sister.anvils> <87vd6ls0jd.fsf@turtle.gmx.de>
In-Reply-To: <87vd6ls0jd.fsf@turtle.gmx.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 4.9.2010 23.42, Sven Joachim wrote:
> On 2010-09-04 21:54 +0200, Hugh Dickins wrote:
>
>> On Sat, 4 Sep 2010, Pekka Enberg wrote:
>>> On Sat,  4 Sep 2010 11:17:14 +0300, Pekka Enberg<penberg@kernel.org>  wrote:
>>>>> This reverts commit 9559fcdbff4f93d29af04478bbc48294519424f5. The commit causes
>>>>> wrong screen resolution on some i915 machines such as MacBook which is a
>>>>> regression from 2.6.35. The issue has been reported multiple times but no fix
>>>>> has emerged:
>>> On Sat, Sep 4, 2010 at 12:21 PM, Chris Wilson<chris@chris-wilson.co.uk>  wrote:
>>>> NAK. You can't simply hide one bug by introducing a much bigger one.
>>> Dude, it's a nasty regression from 2.6.35. What exactly are you NAK'ing here?
>>>
>>>> As you have an affected machine, find which wait_for_vblank() needs to be
>>>> replaced with a msleep(20|50).
>>> The attached patch fixes things here. I'm not a drm developer so I
>>> don't know if it makes technical sense.
>> Many thanks to you, Pekka: I also don't know if it makes technical sense,
>> but it solves the same issue for me, so I can at last use 2.6.36-rc on
>> this laptop.
> Helps for me as well, but I cannot judge whether it makes technical
> sense either.  Thanks, Pekka!
Is someone picking this patch up or am I supposed to send it to Linus?

             Pekka

