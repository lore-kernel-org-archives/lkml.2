Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211Ab0FEG7y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 02:59:54 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39845 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507Ab0FEG7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 02:59:52 -0400
Message-ID: <4C09F5F0.6020902@vflare.org>
Date: Sat, 05 Jun 2010 12:30:00 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Greg KH <greg@kroah.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Minchan Kim <minchan.kim@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       driverdev <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] Rename ramzswap files to zram
References: <1275379286-10453-1-git-send-email-ngupta@vflare.org>	<1275379286-10453-3-git-send-email-ngupta@vflare.org> <20100604123246.3e11022e.akpm@linux-foundation.org>
In-Reply-To: <20100604123246.3e11022e.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2010 01:02 AM, Andrew Morton wrote:
> On Tue,  1 Jun 2010 13:31:24 +0530
> Nitin Gupta <ngupta@vflare.org> wrote:
> 
>> Related changes:
>>  - Modify revelant Kconfig and Makefile accordingly.
>>  - Change include filenames in code.
>>  - Remove dependency on CONFIG_SWAP in Kconfig as zram usage
>> is no longer limited to swap disks.
>>
>> Signed-off-by: Nitin Gupta <ngupta@vflare.org>
>> ---
>>  drivers/staging/Kconfig                            |    2 +-
>>  drivers/staging/Makefile                           |    2 +-
>>  drivers/staging/ramzswap/Kconfig                   |   21 ---------------
>>  drivers/staging/ramzswap/Makefile                  |    3 --
>>  drivers/staging/zram/Kconfig                       |   28 ++++++++++++++++++++
>>  drivers/staging/zram/Makefile                      |    3 ++
>>  drivers/staging/{ramzswap => zram}/xvmalloc.c      |    0
>>  drivers/staging/{ramzswap => zram}/xvmalloc.h      |    0
>>  drivers/staging/{ramzswap => zram}/xvmalloc_int.h  |    0
>>  .../{ramzswap/ramzswap.txt => zram/zram.txt}       |    0
>>  .../{ramzswap/ramzswap_drv.c => zram/zram_drv.c}   |    2 +-
>>  .../{ramzswap/ramzswap_drv.h => zram/zram_drv.h}   |    2 +-
>>  .../ramzswap_ioctl.h => zram/zram_ioctl.h}         |    0
>>  13 files changed, 35 insertions(+), 28 deletions(-)
>>  delete mode 100644 drivers/staging/ramzswap/Kconfig
>>  delete mode 100644 drivers/staging/ramzswap/Makefile
>>  create mode 100644 drivers/staging/zram/Kconfig
>>  create mode 100644 drivers/staging/zram/Makefile
>>  rename drivers/staging/{ramzswap => zram}/xvmalloc.c (100%)
>>  rename drivers/staging/{ramzswap => zram}/xvmalloc.h (100%)
>>  rename drivers/staging/{ramzswap => zram}/xvmalloc_int.h (100%)
>>  rename drivers/staging/{ramzswap/ramzswap.txt => zram/zram.txt} (100%)
>>  rename drivers/staging/{ramzswap/ramzswap_drv.c => zram/zram_drv.c} (99%)
>>  rename drivers/staging/{ramzswap/ramzswap_drv.h => zram/zram_drv.h} (99%)
>>  rename drivers/staging/{ramzswap/ramzswap_ioctl.h => zram/zram_ioctl.h} (100%)
> 
> This is a git-specific thing and doesn't do anything useful for people
> who use plain-old-patch(1) (eg: Greg and me).
> 
> Obviously we can manually type in the commands and put the massive
> file-moving diff together, but it's a bit of a pain.
> 
> Maybe Greg has some magic automated way of turning these into regular
> patches, but I don't.
> 
> 

I used 'git-format-patch -M' as it should be easier to review
(as suggested by Arnd).

Anyways, I'm was not sure if I should be sending normal (non-git-specific)
version of these patches again. So, uploaded them here instead:

single monolithic patch:
http://compcache.googlecode.com/hg/sub-projects/mainline/zramv2_2.6.35-rc1.patch

or, if you prefer patch series:
http://compcache.googlecode.com/hg/sub-projects/mainline/zramv2_patch_series

Thanks,
Nitin



