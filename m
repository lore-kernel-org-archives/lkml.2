Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030327Ab2GLKNw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 06:13:52 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:44068 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933271Ab2GLKNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 06:13:48 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Ravishankar N <cyberax82@gmail.com>,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: Re: [PATCH] fat: Support fallocate on fat.
References: <1341716859-6768-1-git-send-email-linkinjeon@gmail.com>
	<87sjd2766n.fsf@devron.myhome.or.jp>
	<CAKYAXd9mDfDpUj1T1NrY2LUKfwvk94CTXUh5xrEGq8b_rW41rA@mail.gmail.com>
	<871uklp5j7.fsf@devron.myhome.or.jp>
	<CAKYAXd-OD_3Z8=6mBQMvBApje9sN0EiPX8drMXc6pSeMgG8Nnw@mail.gmail.com>
	<87wr2dnp9r.fsf@devron.myhome.or.jp>
	<CAKYAXd_sWKMOQqyPyteoPbcy8_z6=e53DC8sYTcHgMX4EC10Cw@mail.gmail.com>
Date: Thu, 12 Jul 2012 19:13:44 +0900
In-Reply-To: <CAKYAXd_sWKMOQqyPyteoPbcy8_z6=e53DC8sYTcHgMX4EC10Cw@mail.gmail.com>
	(Namjae Jeon's message of "Wed, 11 Jul 2012 13:22:31 +0900")
Message-ID: <87r4shp9rb.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

>> I guess, if Windows truncates the above clusters than file size, it may
>> be prefer to truncate on linux too. We really need it over umount?
>> We never know the file whether corrupted or preallocated.
>>
>> And at least for now, it would be better to put under CONFIG_FAT_FALLOC
>> or such, and warn it as unofficial way to preallocation on the
>> explanation of CONFIG_FAT_FALLOC.
>>
>> Sorry, I'm still not reviewing the detail of code yet, like locking. And
>> I'm still not convinced whether we should add this hack (unofficial way)...
> Hi OGAWA.
> Sorry for late response.
> Currently I am looking for best solution for fallocate support.
> next patch will be upated like the following.
> 1. There is no security bug.
> 2. Fix issue takes long time while preallocating.
> 3. No compatibility issue.
> Let' discuss after seeing next version's patch again.

Sure, thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
