Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932773Ab1DZAVz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 20:21:55 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38152 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167Ab1DZAVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 20:21:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=CT1CAxOBywO453dn9IGtxnBAEAWeMQLos9c02Qw1prG6E7pzkcxuOJwzq5zXAYeFUd
         EAKTYv+yHneuF8BcyT9x+SkmlI8gRTEscPLYc2J7w+Z2td8Z7lPSDB4NsQy0VXxrQnjU
         XK/TyjF2yaTucfllPtIFT8l2fO4ZnPhDjTE0A=
MIME-Version: 1.0
In-Reply-To: <4DB5C8FA.2030700@lwfinger.net>
References: <BANLkTi=fFg6+3DcBNwEOex0jASf1WiBRDQ@mail.gmail.com>
	<4DB4E94C.2060505@lwfinger.net>
	<BANLkTinA6GTTjP=MsVcCqmCA1Tgh-6bHjA@mail.gmail.com>
	<4DB5C8FA.2030700@lwfinger.net>
Date: Tue, 26 Apr 2011 08:21:52 +0800
Message-ID: <BANLkTi=syavY0Tw-Ny9-QhU=_Ryrbmkhfw@mail.gmail.com>
Subject: Re: r8712u cannot set essid
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: lkml <linux-kernel@vger.kernel.org>, wlanfae@realtek.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 3:18 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> Please send me the commands that you want to use, and I'll try to get r8712u
> to support them.

Larry,

All I want is for my iPhone to connect to me notebook, and I use this
command ...

# iwconfig wlan0 mode ad-hoc essid "123"

A little bit of good news is that I got adhoc to work 2 out of 100
tries (with wpa_supplicant on another sreen, and the above iwconfig
command). So, it's working "partially". Once it has an SSID, I could
change it and it'll still work.


> AP mode may not be possible.

So perhaps "CONFIG_R8712_AP=y" should be removed from the kernel if it
does nothing.


Thanks,
Jeff
