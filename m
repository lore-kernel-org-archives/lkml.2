Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419Ab1LTT0u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 14:26:50 -0500
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:51115 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751638Ab1LTT0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 14:26:44 -0500
Message-ID: <4EF0EF8B.1030904@xenotime.net>
Date: Tue, 20 Dec 2011 12:26:51 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] leds-tca6507: allow driver to compile when GPIOLIB
 is not available.
References: <20111220054233.7043.3561.stgit@notabene.brown> <20111220054441.7043.48656.stgit@notabene.brown> <4EF0ED15.5030906@xenotime.net>
In-Reply-To: <4EF0ED15.5030906@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2011 12:16 PM, Randy Dunlap wrote:
> On 12/19/2011 09:44 PM, NeilBrown wrote:
>> This driver can configure the outputs as GPIO line instead of LEDs.  But
>> that only works if GPIOLIB is available.  So make that code conditional
>> on the library's availability.
>>
>> Also remove the 'teardown' callback as it is never called and should
>> never be needed.
>>
>> Signed-off-by: NeilBrown <neilb@suse.de>
> 
> Thanks.  This builds.
> 
> Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Neil,
You might want to check this also:

drivers/leds/leds-tca6507.c:358:17: warning: array subscript is above array bounds
drivers/leds/leds-tca6507.c:357:17: warning: array subscript is above array bounds


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
