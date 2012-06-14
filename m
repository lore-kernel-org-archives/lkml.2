Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab2FNAMb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 20:12:31 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:57607 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab2FNAMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 20:12:30 -0400
Message-ID: <4FD92C5E.6070602@linaro.org>
Date: Wed, 13 Jun 2012 17:12:14 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Anton Vorontsov <anton.vorontsov@linaro.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Shuah Khan <shuahkhan@gmail.com>, arve@android.com,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: Re: [PATCH v5 0/11] Merge ram_console into pstore
References: <20120526131747.GA15054@lizard> <20120614000504.GA11990@kroah.com>
In-Reply-To: <20120614000504.GA11990@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061400-5518-0000-0000-00000526B5F9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2012 05:05 PM, Greg Kroah-Hartman wrote:
> On Sat, May 26, 2012 at 06:17:48AM -0700, Anton Vorontsov wrote:
>> The old ram_console driver is removed. This might probably cause
>> some pain for out-of-tree code, as it would need to be adjusted...
>> but "no pain, no gain"? :-) Though, if there's some serious resistance,
>> we can probably postpone the last two patches.
> What out-of-tree code would care about this?
I think he's referring to the persistent_ftrace work in the Android tree.

Anton did send out patches to try to get equivalent functionality 
working with pstore, but I don't know if Colin or anyone else from the 
Android team has had a chance to review it and make sure its sufficient.

thanks
-john

