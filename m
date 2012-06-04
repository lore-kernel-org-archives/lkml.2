Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab2FDInF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 04:43:05 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:55789 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab2FDInD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 04:43:03 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1206040822500.421@bushbaby.sonytel.be>
References: <CAFU-uVs_Gwacxj74cyekY2gv+zAq+Spba7nfPLdTc_dR3y8CYw@mail.gmail.com>
 <alpine.DEB.2.00.1206040822500.421@bushbaby.sonytel.be>
From: Philipp Riemer <ruderphilipp@gmail.com>
Date: Mon, 4 Jun 2012 10:42:41 +0200
Message-ID: <CAFU-uVvzYtmNKvVG+mMsc_o8HPe=y-ay=ZERNdCXGCf4ZE5Dsg@mail.gmail.com>
Subject: Re: [GIT PULL] new mailmap file for the linux kernel git repository
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Paul Mundt <lethal@linux-sh.org>,
        =?ISO-8859-1?Q?Michael_B=FCsch?= <m@bues.ch>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Jiri Kosina <jkosina@suse.cz>,
        =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Wang Chen <ellre923@gmail.com>,
        Greg KH <greg@kroah.com>, Jonathan Corbet <corbet@lwn.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

2012/6/4 Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>:
>
>    Hi Philipp,
>
> On Wed, 16 May 2012, Philipp Riemer wrote:
>> +Geert Uytterhoeven <geert.uytterhoeven@eu.sony.com> <Geert.Uytterhoeven@eu.sony.com>
>> +Geert Uytterhoeven <geert.uytterhoeven@eu.sony.com> <Geert.Uytterhoeven@sonycom.com>
>
> I just went through "git help shortlog" to find out the meaning of the fields
> and their order.
Thank you for the hint. I added a line to the top of the .mailmap file
that explains the syntax.

> In my case, I want the reverse mapping: I want to map the FLOSS- and
> vger-incompatible <Geert.Uytterhoeven@eu.sony.com> to
> <Geert.Uytterhoeven@sonycom.com>.
I changed it. You can check it online at
<https://github.com/ruderphilipp/linux/blob/mailmap-changes/.mailmap#L822>.

> Thanks for updating!
At least one, who seems to see a sense in my work... Thanks for your support!

> With kind regards,
>
> Geert Uytterhoeven
> Software Architect
> Technology and Software Centre Europe
>
> [...]

Cheers,
Philipp
