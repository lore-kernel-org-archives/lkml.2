Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681Ab1CPVlt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 17:41:49 -0400
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:37531 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755623Ab1CPVlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 17:41:42 -0400
Message-ID: <4D812E5C.1010708@fastmail.fm>
Date: Wed, 16 Mar 2011 22:40:44 +0100
From: Anders Eriksson <aeriksson@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20101003 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: Jerome Glisse <j.glisse@gmail.com>
CC: Alex Deucher <alexdeucher@gmail.com>, airlied@redhat.com,
        xorg-driver-ati@lists.x.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: Radeon jittery post 2.6.35
References: <4D7CCFC3.7030906@fastmail.fm>	<AANLkTinug=6d6BKrZvA1HGZWNqgUNJKOBC3f8J5B_5oJ@mail.gmail.com>	<AANLkTik0nXX+WEwa2xZ9VV+yHwrWnx+tYNdZXPEjk=SO@mail.gmail.com>	<4D7FD2FB.9090505@fastmail.fm> <AANLkTikpBh2+OU2MUFo63oq9kBte7MK7rgwcuDKSwA_j@mail.gmail.com>
In-Reply-To: <AANLkTikpBh2+OU2MUFo63oq9kBte7MK7rgwcuDKSwA_j@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.252.238.16
X-Scan-Result: No virus found in message 1PzySa-00014j-Be.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PzySa-00014j-Be 2bba5fdacd1aff991ea36acaa0276861
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 03/15/11 22:08, Jerome Glisse wrote:
> EDID failure could very well explain it, EDID retrieval seems to fails
> on some GPU under some circonstance (when there is CPU load that
> interfer with i2c timing i guess). Does the log have the edid failure
> message when the tv is jittering ? Or is it the otherway around ?
>
> Cheers,
> Jerome
It seems to be related to whether the TV is on (on that HDMI source) or not.
Mar 16 09:50:41 mynet kernel: [  933.060281] [drm:radeon_dvi_detect]
*ERROR* HDMI-A-1: probed a monitor but no|invalid EDID
Mar 16 09:53:46 mynet kernel: [ 1117.724206] [drm:radeon_dvi_detect]
*ERROR* HDMI-A-1: probed a monitor but no|invalid EDID
Mar 16 09:54:47 mynet kernel: [ 1179.218109] [drm:radeon_dvi_detect]
*ERROR* HDMI-A-1: probed a monitor but no|invalid EDID
Mar 16 09:54:57 mynet kernel: [ 1189.411883] [drm:radeon_dvi_detect]
*ERROR* HDMI-A-1: probed a monitor but no|invalid EDID
Mar 16 09:55:32 mynet kernel: [ 1220.050871] [drm:radeon_dvi_detect]
*ERROR* HDMI-A-1: probed a monitor but no|invalid EDID
Mar 16 20:27:51 mynet kernel: [  952.693085] [drm:radeon_dvi_detect]
*ERROR* HDMI Type A-1: probed a monitor but no|invalid EDID
Mar 16 21:30:21 mynet kernel: [ 2272.384410] [drm:radeon_dvi_detect]
*ERROR* HDMI-A-1: probed a monitor but no|invalid EDID
Mar 16 21:32:44 mynet kernel: [ 2415.931947] [drm:radeon_dvi_detect]
*ERROR* HDMI-A-1: probed a monitor but no|invalid EDID
Mar 16 21:40:45 mynet kernel: [ 2896.698214] [drm:radeon_dvi_detect]
*ERROR* HDMI-A-1: probed a monitor but no|invalid EDID
Mar 16 21:45:05 mynet kernel: [ 3152.643541] [drm:radeon_dvi_detect]
*ERROR* HDMI-A-1: probed a monitor but no|invalid EDID
Mar 16 21:53:00 mynet kernel: [ 3631.146133] [drm:radeon_dvi_detect]
*ERROR* HDMI-A-1: probed a monitor but no|invalid EDID


The TV was
off at about 10 AM this morning (the HTPC was on playing music)
on a couple of hours in the afternoon showing the RS690 HDMI
on at 20:50-22:00 NOT showing the RS690 HDMI

Unfortunately I'm not sure what the TV's state was at 20:27:51

/A
