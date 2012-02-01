Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab2BARKf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 12:10:35 -0500
Received: from claw.goop.org ([74.207.240.146]:34430 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986Ab2BARKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 12:10:34 -0500
Message-ID: <4F297206.4070900@goop.org>
Date: Wed, 01 Feb 2012 09:10:30 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT] HID
References: <alpine.LNX.2.00.1201052218200.24984@pobox.suse.cz> <4F098C29.9010101@goop.org> <alpine.LNX.2.00.1201081739360.24984@pobox.suse.cz> <4F1132B3.3000909@goop.org> <alpine.LNX.2.00.1202011247550.18918@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1202011247550.18918@pobox.suse.cz>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2012 03:48 AM, Jiri Kosina wrote:
> On Sat, 14 Jan 2012, Jeremy Fitzhardinge wrote:
>
>>> which is based on the power supply scope changes in the battery.git tree; I'm not quite
>>> sure how to sequence that into mainline.
>>> I will look into it.
>> The power changes are in now, so you could try pushing them as a late push.
>>
>> (Linus: I had some changes that depended on both the HID and
>> power_supply subsystems, so they needed to wait until you'd pulled both.)
> Jeremy,
>
> I have been completely offline for ~20 days, and am slowly getting back on 
> track now, so I will process those shortly. Sorry for late response.

No problem, they're not urgent or anything.  It would be nice to get
them into the next release if at all possible so powerd can start using
them, but it has lasted this long wthout...

Thanks,
    J
