Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab3ABMCl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 07:02:41 -0500
Received: from mail.skyhub.de ([78.46.96.112]:43266 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602Ab3ABMCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 07:02:37 -0500
Date: Wed, 2 Jan 2013 13:02:48 +0100
From: Borislav Petkov <bp@alien8.de>
To: Antti Palosaari <crope@iki.fi>
Cc: Shuah Khan <shuahkhan@gmail.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Andy Furniss <andyqos@ukfsn.org>, Alex Deucher <alexdeucher@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        dri-devel@lists.freedesktop.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: radeon 0000:02:00.0: GPU lockup CP stall for more than 10000msec
Message-ID: <20130102120248.GC6181@x1.alien8.de>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Antti Palosaari <crope@iki.fi>, Shuah Khan <shuahkhan@gmail.com>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	Andy Furniss <andyqos@ukfsn.org>,
	Alex Deucher <alexdeucher@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	dri-devel@lists.freedesktop.org,
	lkml <linux-kernel@vger.kernel.org>
References: <20121223105527.GA6230@liondog.tnic>
 <50D6E491.3030801@ukfsn.org>
 <20121223110730.GC6230@liondog.tnic>
 <50D6E8A4.1030204@ukfsn.org>
 <20121223113153.GA8918@liondog.tnic>
 <20121223115133.GA229@x4>
 <20121223122210.GA4460@liondog.tnic>
 <20121223133102.GA8153@liondog.tnic>
 <CAKocOOPO7ZhybEgKfCkpna+KbpGgajMp6HuHbO9m9uT3gUtP0g@mail.gmail.com>
 <50E3907C.4040106@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50E3907C.4040106@iki.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2013 at 03:42:20AM +0200, Antti Palosaari wrote:
> I ended up also that same commit after bisecting from current 3.8
> master.
>
> 01:05.0 VGA compatible controller: ATI Technologies Inc 760G [Radeon
> 3000] It is ASUS M5A78L-M/USB3 with integrated GPU.
>
> I cannot even boot unless graphical boot is removed from Fedora 17
> boot options (rhgb quiet). Random GPU crashes still.

You could try the temporary R600-only fix although I can't see whether
your GPU is also an R600 ASIC or something different by staring at the
model string above:

http://marc.info/?l=dri-devel&m=135628734704029

HTH.

-- 
Regards/Gruss,
Boris.
