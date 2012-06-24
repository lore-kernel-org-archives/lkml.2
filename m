Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572Ab2FXPox (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 11:44:53 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:36493 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752607Ab2FXPow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 11:44:52 -0400
Message-ID: <4FE735D7.7080102@xenotime.net>
Date: Sun, 24 Jun 2012 08:44:23 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Jimmy Pan <dspjmt@gmail.com>
CC: Anatol Pomozov <anatol.pomozov@gmail.com>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix typo in printed messages
References: <1340492074-13664-1-git-send-email-anatol.pomozov@gmail.com> <1340492074-13664-2-git-send-email-anatol.pomozov@gmail.com> <CAGTyHCpSa8hSuiBS53t9GuXfv6v_AYbCv8Wn=snHqiG1HHtbRA@mail.gmail.com>
In-Reply-To: <CAGTyHCpSa8hSuiBS53t9GuXfv6v_AYbCv8Wn=snHqiG1HHtbRA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2012 06:09 AM, Jimmy Pan wrote:

> On Sun, Jun 24, 2012 at 6:54 AM, Anatol Pomozov
> <anatol.pomozov@gmail.com> wrote:
>> Coult -> Could
>> ---
>>  arch/sparc/kernel/vio.c               |    2 +-
>>  drivers/net/wireless/b43/main.c       |    2 +-
>>  drivers/net/wireless/b43legacy/main.c |    2 +-
>>  3 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/sparc/kernel/vio.c b/arch/sparc/kernel/vio.c
>> index 5cffdc5..3e244f3 100644
>> --- a/arch/sparc/kernel/vio.c
>> +++ b/arch/sparc/kernel/vio.c
>> @@ -443,7 +443,7 @@ static int __init vio_init(void)
>>        root_vdev = vio_create_one(hp, root, NULL);
>>        err = -ENODEV;
>>        if (!root_vdev) {
>> -               printk(KERN_ERR "VIO: Coult not create root device.\n");
>> +               printk(KERN_ERR "VIO: Could not create root device.\n");
>>                goto out_release;
>>        }
>>
>> diff --git a/drivers/net/wireless/b43/main.c
>> b/drivers/net/wireless/b43/main.c
>> index acd03a4..1b988f2 100644
>> --- a/drivers/net/wireless/b43/main.c
>> +++ b/drivers/net/wireless/b43/main.c
>> @@ -3767,7 +3767,7 @@ static int b43_switch_band(struct b43_wl *wl, struct
>> ieee80211_channel *chan)
>>        if (prev_status >= B43_STAT_STARTED) {
>>                err = b43_wireless_core_start(up_dev);
>>                if (err) {
>> -                       b43err(wl, "Fatal: Coult not start device for "
>> +                       b43err(wl, "Fatal: Could not start device for "
>>                               "selected %s-GHz band\n",
>>                               band_to_string(chan->band));
>>                        b43_wireless_core_exit(up_dev);
>> diff --git a/drivers/net/wireless/b43legacy/main.c
>> b/drivers/net/wireless/b43legacy/main.c
>> index cd9c9bc..eae691e 100644
>> --- a/drivers/net/wireless/b43legacy/main.c
>> +++ b/drivers/net/wireless/b43legacy/main.c
>> @@ -2633,7 +2633,7 @@ static int b43legacy_switch_phymode(struct
>> b43legacy_wl *wl,
>>        if (prev_status >= B43legacy_STAT_STARTED) {
>>                err = b43legacy_wireless_core_start(up_dev);
>>                if (err) {
>> -                       b43legacyerr(wl, "Fatal: Coult not start device
>> for "
>> +                       b43legacyerr(wl, "Fatal: Could not start device
>> for "
>>                               "newly selected %s-PHY mode\n",
>>                               phymode_to_string(new_mode));
>>                        b43legacy_wireless_core_exit(up_dev);
>> --
> 
> 
> With no offense, I am a newbie too. I wonder if we need such kind of refinement.
> --


Yes, spelling mistakes in user-visible messages should be fixed.


-- 
~Randy
