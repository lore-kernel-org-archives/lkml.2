Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758154Ab1DZD0N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 23:26:13 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47826 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757935Ab1DZD0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 23:26:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=KhTM1IMraAI8jGkH/QNUh18/xc8kh5wFIqsdBjA5GMOEOs70o2B3K8qFnZDCAex/Tr
         MK9uCGu1EkM0c4fUtlUIhpAafKAYMMEHvGtFJce0LeUgV8C0s66qfxD1h3w1YaZHmBJ3
         rf1b/9frSghk27Sk8j/Dd0dSnThqijIbEeFtk=
MIME-Version: 1.0
In-Reply-To: <4DB61645.8010001@lwfinger.net>
References: <BANLkTi=fFg6+3DcBNwEOex0jASf1WiBRDQ@mail.gmail.com>
	<4DB4E94C.2060505@lwfinger.net>
	<BANLkTinA6GTTjP=MsVcCqmCA1Tgh-6bHjA@mail.gmail.com>
	<4DB5C8FA.2030700@lwfinger.net>
	<BANLkTi=syavY0Tw-Ny9-QhU=_Ryrbmkhfw@mail.gmail.com>
	<4DB61645.8010001@lwfinger.net>
Date: Tue, 26 Apr 2011 11:26:10 +0800
Message-ID: <BANLkTikWHxEnzZ+H1OgFv7AdmpmmcwVuzA@mail.gmail.com>
Subject: Re: r8712u cannot set essid
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: lkml <linux-kernel@vger.kernel.org>, wlanfae@realtek.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 8:48 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 04/25/2011 07:21 PM, Jeff Chua wrote:
>> A little bit of good news is that I got adhoc to work 2 out of 100
>> tries (with wpa_supplicant on another sreen, and the above iwconfig
>> command). So, it's working "partially". Once it has an SSID, I could
>> change it and it'll still work.
>
> Please try the attached patch.

Tried, but didn't make any difference.

Now I can make adhoc work 100% if I first put the device in wpa2
infrastructure and associates it with an AP. Then kill the
wpa_supplicant process, and start a new wpa_supplicant with adhoc
config.

If I just start with the wpa_supplicant adhoc config, it'll never set the ssid.

So, something is not right in the r8712u module or may be the firmware?

Thanks,
Jeff
