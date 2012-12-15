Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562Ab2LOMl0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 07:41:26 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:53411 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755627Ab2LOMlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 07:41:25 -0500
Message-ID: <50CC6FE3.6060705@ahsoftware.de>
Date: Sat, 15 Dec 2012 13:41:07 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Jonathan Cameron <jic23@kernel.org>
CC: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>,
        srinivas pandruvada <srinivas.pandruvada@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 2/4 RESEND] iio: Add Usage IDs for HID time sensors.
References: <50C73AFC.1050904@jic23.retrosnub.co.uk> <1355250106-3114-1-git-send-email-holler@ahsoftware.de> <1355250106-3114-2-git-send-email-holler@ahsoftware.de> <50CC599E.8060004@kernel.org>
In-Reply-To: <50CC599E.8060004@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 15.12.2012 12:06, schrieb Jonathan Cameron:
> On 12/11/2012 06:21 PM, Alexander Holler wrote:
>> These are Usage IDs for the attributes year, month, day,
>> hour, minute and second, needed to read HID time sensors.
>>
>> Signed-off-by: Alexander Holler <holler@ahsoftware.de>
> This has gotten very messy to follow.  Could you resend the

I aggree. The workflow (ping-pong until a patch is almost perfect, 
without typos and style glitches and makes the maintainers eyes happy) 
is horrible and requires quite a lot goodwill and patience on every 
side. Not the stuff people like to do on a voluntarily basis.

So thanks to everyone who still follows.

The whole series (now 5 patches) follows. I mark all of them as RESEND 
to indicate that no changes were done since I've send them the last time.

> patches (without the first) with Jiri cc'd as well
> (as some of this is in his domain as HID maintainer).

Sorry, almost the whole series (5-1 = 4) follows. ;)

>
> Given this makes quite a few changes in IIO drivers I'm happy
> to take the lot through the IIO tree but to do that I would
> like a go ahead from Jiri + either Andrew or Alessandro
> (for rtc side of things).

Thanks again.

Alexander

