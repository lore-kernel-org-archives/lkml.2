Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606Ab2DWHw5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 03:52:57 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:64930 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449Ab2DWHw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 03:52:56 -0400
Message-ID: <4F950A4B.6080508@gmail.com>
Date: Mon, 23 Apr 2012 10:52:43 +0300
From: Nikolai Kondrashov <spbnick@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] hid: Enable report fixup on rebind
References: <1335097300-11881-1-git-send-email-rydberg@euromail.se> <alpine.LNX.2.00.1204222325380.1856@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1204222325380.1856@pobox.suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2012 12:27 AM, Jiri Kosina wrote:
> On Sun, 22 Apr 2012, Henrik Rydberg wrote:
>> This patchset contains a resolution to the problem with
>> driver-specific modification of the report descriptor. The core of the
>> problem lies with the dual semantics of hid_parse_report(), which is
>> therefore split into two functions. As a consequence, the hid core can
>> handle the rebind case internally, with no changes to the
>> drivers. Out-of-tree drivers will work fine as long as they operate in
>> the same way as the in-kernel drivers.
>>
>> The first two patches are bug fixes found in the process. I am hoping
>> for some test feedback on those. The third patch is the main one.
>
> Hi Henrik,
>
> thanks a lot for looking into this. I will look into the patches in more
> detail tomorrow. I am now just adding Nikolai to CC, as he was the first
> one to bring this up and actually has a driver that exposed the fact that
> just freeing/reinstatiating rdesc is not enough.

Thanks Henrik, Jiri!

I'll be testing this as soon as I can.

Sincerely,
Nick
