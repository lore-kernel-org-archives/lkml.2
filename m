Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932514Ab1AKSHV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 13:07:21 -0500
Received: from gretel.risen.be ([78.46.99.137]:37702 "EHLO gretel.risen.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756246Ab1AKSHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 13:07:18 -0500
Message-ID: <4D2C9C52.1000304@aquazul.com>
Date: Tue, 11 Jan 2011 19:07:14 +0100
From: Mourad De Clerck <mourad@aquazul.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101213 Icedove/3.1.7
MIME-Version: 1.0
To: Richard Hughes <hughsient@gmail.com>
CC: Matthew Garrett <mjg59@srcf.ucam.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Richard Purdie <rpurdie@linux.intel.com>, linux-kernel@vger.kernel.org,
        Richard Hughes <richard@hughsie.com>
Subject: Re: mbp_nvidia_bl: Remove DMI dependency
References: <4D145EB5.7090205@aquazul.com>	<20110104143651.8f6d62e0.akpm@linux-foundation.org>	<4D2C8864.8030909@aquazul.com>	<20110111164834.GA28175@srcf.ucam.org> <AANLkTinovDucigOX+kidh+KwekbZP65moy7P2pYNn25L@mail.gmail.com>
In-Reply-To: <AANLkTinovDucigOX+kidh+KwekbZP65moy7P2pYNn25L@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/11 18:05, Richard Hughes wrote:
>>> The only slight change is that gnome-power-manager needs to be updated
>>> to use /sys/class/backlight/apple_backlight instead of mbp_backlight.
>>
>> gnome-power-manager needs not to have a hardcoded list of backlights.
> 
> Mourad, how many devices do you have in /sys/class/backlight?

I have two: nv_backlight and mbp_backlight (now apple_backlight). The
trouble is that nouveau's nv_backlight is broken on my hardware (NVAF).

(I think it's this issue:
https://bugzilla.redhat.com/show_bug.cgi?id=625171 - max_brightness is
wrong)

When I remove nv_backlight completely and just have apple_backlight,
g-p-m works properly. When they're both there, g-p-m prefers nv_backlight.

-- Mourad
