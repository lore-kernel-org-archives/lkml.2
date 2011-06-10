Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264Ab1FJRr5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 13:47:57 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59881 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab1FJRrz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 13:47:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=isCaf+3q+Ixrt6C+RcQdExc6tUzuan2UpwlAlEmphPqNG2NGUS7xlsvka90gd3nvBn
         NNR8f6vOri7zijb7xIbyy86DIVgkVuLdUadxfe220F/XVnoHFKrv3XpckjeGG5MxefZN
         3YoNQykjmG4mtwj9agt+TtOAKFhh2bD0MZ8RI=
MIME-Version: 1.0
In-Reply-To: <20110610173004.GJ26441@sirena.org.uk>
References: <1307726331-28618-1-git-send-email-lars@metafoo.de>
 <1307726331-28618-2-git-send-email-lars@metafoo.de> <20110610173004.GJ26441@sirena.org.uk>
From: Mike Frysinger <vapier@gentoo.org>
Date: Fri, 10 Jun 2011 13:47:34 -0400
X-Google-Sender-Auth: zf_KqxbWm1RZ3go04GHOLym0A98
Message-ID: <BANLkTimBJbkYJnU5vgmo+a5eerRroE1uBg@mail.gmail.com>
Subject: Re: [Device-drivers-devel] [alsa-devel] [PATCH 2/3] ASoC: Blackfin:
 Add bf5xx-adau1701 machine driver
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        device-drivers-devel@blackfin.uclinux.org,
        uclinux-dist-devel@blackfin.uclinux.org, Liam Girdwood <lrg@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 13:30, Mark Brown wrote:
> On Fri, Jun 10, 2011 at 07:18:50PM +0200, Lars-Peter Clausen wrote:
>> Add a machine driver to support the ADAU1701 SigmaDSP processors on
>> Analog Devices BF5XX evaluation boards.
>
> So, I keep on complaining about the way these drivers are just generic
> to any random Blackfin plus CODEC combination rather than being board
> specific.  It'd be good if we could improve this, even adding something
> into the driver name to make it clear these are for the EVB would help.

i know you keep complaining, but i honestly dont understand why this
is undesirable.  connecting a codec to a Blackfin is pretty much
always the same.  you pick a SPORT # and that's about it.

the spi cs and i2c address could differ (so maybe make that a field
for the platform resources), but otherwise i dont see why people
should have to copy & paste the same code to change all of 4 bytes.
-mike
