Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab1JSGLe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 02:11:34 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:49277 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab1JSGLd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 02:11:33 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1110182305110.7719@chino.kir.corp.google.com>
References: <20111019060108.GA11588@gamma.logic.tuwien.ac.at>
	<alpine.DEB.2.00.1110182305110.7719@chino.kir.corp.google.com>
Date: Wed, 19 Oct 2011 09:11:32 +0300
X-Google-Sender-Auth: 1WQcQw4VjqAn4LYQE6T4OGzGu3c
Message-ID: <CAOJsxLFXBQXDtjGkuHV8fpxSy4U0dOdzBm6=4xfy2dMQo7NvOg@mail.gmail.com>
Subject: Re: iwlagn is getting very shaky
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: David Rientjes <rientjes@google.com>
Cc: Norbert Preining <preining@logic.at>, linux-kernel@vger.kernel.org,
        ipw3945-devel@lists.sourceforge.net,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>, ilw@linux.intel.com,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 19, 2011 at 9:09 AM, David Rientjes <rientjes@google.com> wrote:
> On Wed, 19 Oct 2011, Norbert Preining wrote:
>
>> Hi everyone
>>
>> (please Cc),
>>
>> I am currently running 3.1.0-rc10, and I am having a hard time with
>> the wlan network here at the university.
>>
>> For quite some time, like 10min, it is fine, then suddently the
>> iwlagn driver gives up on me and connection is dropped.
>>
>> In the log file I see:
>> [  172.137011] iwlagn 0000:06:00.0: Tx aggregation enabled on ra = 00:24:c4:ab:bd:ef tid = 0
>> [  821.841016] iwlagn 0000:06:00.0: Tx aggregation enabled on ra = 00:24:c4:ab:bd:ef tid = 6
>> [ 1095.580735] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 1/3)
>> [ 1095.780076] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 2/3)
>> [ 1095.980101] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 3/3)
>> [ 1096.180117] wlan0: direct probe to 00:24:c4:ab:bd:e0 timed out
>> [ 1105.255464] wlan0: deauthenticating from 00:24:c4:ab:bd:ef by local choice (reason=2)
>> [ 1105.255519] iwlagn 0000:06:00.0: Stopping AGG while state not ON or starting
>> [ 1105.265581] cfg80211: Calling CRDA for country: JP
>> [ 1105.271476] wlan0: authenticate with 00:24:c4:ab:bd:e0 (try 1)
>> [ 1105.468105] wlan0: authenticate with 00:24:c4:ab:bd:e0 (try 2)
>> [ 1105.668110] wlan0: authenticate with 00:24:c4:ab:bd:e0 (try 3)
>> [ 1105.868090] wlan0: authentication with 00:24:c4:ab:bd:e0 timed out
>> [ 1113.667890] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 1/3)
>> [ 1113.864116] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 2/3)
>> [ 1114.064095] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 3/3)
>> [ 1114.264109] wlan0: direct probe to 00:24:c4:ab:bd:e0 timed out
>>
>> Somewhere around 1100 the connection is gone and never comes back again.
>>
>> I tried removing the driver module from the kernel and reinserting it,
>> tried to turn on and off the hardware swithc (rfkill), all without
>> no success, the wlan connection remains dead until I reboot.
>>
>> I am not sure exactely when it started, I guess somewhere in the
>> 3.1 cycle, before I was permanently working wiht wlan, now I always
>> plug in the cable.
>>
>> If there is any way to track down this, or any suggestions how I can
>> debug it, please let me know.
>>
>> Hardware: Sony VGN-Z11, Intel(R) WiFi Link 5100 AGN, REV=0x54
>> L1 Enabled; Disabling L0S
>> device EEPROM VER=0x11e, CALIB=0x4
>> Device SKU: 0Xf0
>> Tunable channels: 13 802.11bg, 24 802.11a channels
>> loaded firmware version 8.83.5.1 build 33692 (EXP)
>>
>>
>> On the other hand, the same laptop with the very same configuration
>> works very nicely in my flat's wlan, which is some dirt cheap Japanese
>> only wlan router.
>>
>
> There have been recent issues in 3.1-rc9 reported with iwlagn, see the
> thread at https://lkml.org/lkml/2011/10/15/107 even though you have
> different hardware.  Adding Wey-Yi Guy from Intel and the linux-wireless
> mailing list to the cc.

I'm seeing very similar problems with 3.1-rc9 when my laptop is
connected to an iPhone WiFi hotspot. Works just fine at home where I
use Airport Express.

                        Pekka
