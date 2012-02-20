Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327Ab2BTHCM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 02:02:12 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37364 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab2BTHCL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 02:02:11 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of myungjoo.ham@gmail.com designates 10.50.36.230 as permitted sender) smtp.mail=myungjoo.ham@gmail.com; dkim=pass header.i=myungjoo.ham@gmail.com
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
In-Reply-To: <20120220022430.GI3194@opensource.wolfsonmicro.com>
References: <1327021317-10222-1-git-send-email-myungjoo.ham@samsung.com>
	<1328856038-21912-1-git-send-email-myungjoo.ham@samsung.com>
	<1328856038-21912-4-git-send-email-myungjoo.ham@samsung.com>
	<20120220022430.GI3194@opensource.wolfsonmicro.com>
Date: Mon, 20 Feb 2012 16:02:11 +0900
X-Google-Sender-Auth: L9HzuF3E2qlyIrRiQ3IFBjTSLqk
Message-ID: <CAJ0PZbQToSWbPQPF_ku9rmuesNs+aYHdVEsoBvMFijz3PVL1qA@mail.gmail.com>
Subject: Re: [PATCH v5 3/5] Extcon: support multiple states at a device.
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, NeilBrown <neilb@suse.de>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnevag?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, Greg KH <gregkh@suse.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        John Stultz <john.stultz@linaro.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 11:24 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Fri, Feb 10, 2012 at 03:40:36PM +0900, MyungJoo Ham wrote:
>
>> +     [EXTCON_AUDIO_IN]       = "Audio-in",
>> +     [EXTCON_AUDIO_OUT]      = "Audio-out",
>
> Can I suggest making these more specific - how about
>
>        [EXTCON_LINE_IN]        = "Line-in",
>        [EXTCON_LINE_OUT]       = "Line-out",
>        [EXTCON_MIC_IN]         = "Microphone",
>        [EXTCON_HEADPHONE_OUT]  = "Headphone",
>
> as a starting point?  The distinction between line and the other two is
> often pretty important from a UI/system interaction point of view.

Sure, this looks more generic. I'll add them along with SPDIF in/out.

>
>> +     /* TODO: remove before submit */
>> +     pr_info("[%s][%d]\n", buffer, enabled);
>
> :)

Whoops...

-- 
MyungJoo Ham, Ph.D.
System S/W Lab, Software Center, Samsung Electronics
