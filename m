Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045Ab0HMGhP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 02:37:15 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47391 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799Ab0HMGhK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 02:37:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Lw5qpqKclVTjHJLe8jjPh0I5kHWzFKfcPmgFemuKUkzauNIc+Rlww6s5mqKNgZ8TEV
         gDvurA5hWhD0T452M72fW2P3tQBeUkuMXux0//y6bX+UEmrtFWVmZc4IahFf7fX+ML8O
         xsqXkQw8WDruq02BuH+peKrCprAPAhBaVBB/w=
MIME-Version: 1.0
In-Reply-To: <1281672482-10909-1-git-send-email-ike.pan@canonical.com>
References: <1281672482-10909-1-git-send-email-ike.pan@canonical.com>
Date: Fri, 13 Aug 2010 08:37:09 +0200
Message-ID: <AANLkTikBZ2SmqWavZ8bw69yQ_A5GTTcB13RKEzUuUcx3@mail.gmail.com>
Subject: Re: [PATCH] ideapad-laptop: add new driver
From: Corentin Chary <corentin.chary@gmail.com>
To: Ike Panhc <ike.pan@canonical.com>
Cc: platform-driver-x86@vger.kernel.org, linux-acpi@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, Thomas Renninger <trenn@suse.de>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 13, 2010 at 6:08 AM, Ike Panhc <ike.pan@canonical.com> wrote:
> ideapad-laptop is a new driver which enable hotkeys on Lenovo Ideapad laptops
>
> The driver will bind on ACPI HID:VPC2004. When hotkey pressed, the notify
> function will be called and query EC to tell which key pressed.
>
> Hotkeys enabled listed below:
>  * LCD backlight switch - reports KEY_DISPLAY_OFF
>  * One key restore - reports KEY_PROG1
>  * Brightness Up/down - reports KEY_BRIGHTNESS_CYCLE
>   Both up/down keys reports the same event. Need to find other way to detect
>  * Touchpad switch - reports KEY_F13
>  * Video output switch - reports KEY_SWITCHVIDEOMODE
>  * Camera switch - reports KEY_CAMERA
>  * Video resolution switch - reports KEY_VIDEO_NEXT
>  * S/W rfkill key - reports KEY_WLAN
>
> The developing git tree as reference:
>  git://kernel.ubuntu.com/ikepanhc/ideapad-laptop.git
>
> This patch made against current checkout of mainline kernel.

Cool, now we got two ideapad drivers :p.

David just sent an rfkill driver to this list. Maybe you could merge your work ?

Thanks,
-- 
Corentin Chary
http://xf.iksaif.net
