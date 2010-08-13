Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab0HMGyI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 02:54:08 -0400
Received: from adelie.canonical.com ([91.189.90.139]:50511 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070Ab0HMGyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 02:54:05 -0400
Message-ID: <4C64EC01.9040103@canonical.com>
Date: Fri, 13 Aug 2010 14:53:53 +0800
From: Ike Panhc <ike.pan@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Corentin Chary <corentin.chary@gmail.com>
CC: platform-driver-x86@vger.kernel.org, linux-acpi@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, Thomas Renninger <trenn@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ideapad-laptop: add new driver
References: <1281672482-10909-1-git-send-email-ike.pan@canonical.com> <AANLkTikBZ2SmqWavZ8bw69yQ_A5GTTcB13RKEzUuUcx3@mail.gmail.com>
In-Reply-To: <AANLkTikBZ2SmqWavZ8bw69yQ_A5GTTcB13RKEzUuUcx3@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2010 02:37 PM, Corentin Chary wrote:
> On Fri, Aug 13, 2010 at 6:08 AM, Ike Panhc <ike.pan@canonical.com> wrote:
>> ideapad-laptop is a new driver which enable hotkeys on Lenovo Ideapad laptops
>>
>> The driver will bind on ACPI HID:VPC2004. When hotkey pressed, the notify
>> function will be called and query EC to tell which key pressed.
>>
>> Hotkeys enabled listed below:
>>  * LCD backlight switch - reports KEY_DISPLAY_OFF
>>  * One key restore - reports KEY_PROG1
>>  * Brightness Up/down - reports KEY_BRIGHTNESS_CYCLE
>>   Both up/down keys reports the same event. Need to find other way to detect
>>  * Touchpad switch - reports KEY_F13
>>  * Video output switch - reports KEY_SWITCHVIDEOMODE
>>  * Camera switch - reports KEY_CAMERA
>>  * Video resolution switch - reports KEY_VIDEO_NEXT
>>  * S/W rfkill key - reports KEY_WLAN
>>
>> The developing git tree as reference:
>>  git://kernel.ubuntu.com/ikepanhc/ideapad-laptop.git
>>
>> This patch made against current checkout of mainline kernel.
> 
> Cool, now we got two ideapad drivers :p.
> 
> David just sent an rfkill driver to this list. Maybe you could merge your work ?
> 
> Thanks,
Could you point me where is the rfkill driver? Sorry I do not find it.

I will see what I can do.

Thanks.
