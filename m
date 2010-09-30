Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147Ab0I3Per (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 11:34:47 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63024 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932083Ab0I3Peq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 11:34:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Df2btobKzoiyUWbgqUzJoStaShFyUUNTndB5UAN9Zvky7OS5/WJO3edPU2ZlthNA8c
         dknfb4oZQsKd4TuitCAMDvt8W77bh/z6E/7TcMZ4r1Y3uKLikusPFoA3EUgaZOPKyflN
         3EEHFG7jRssCB9dKDV7bbCbtJ3dSSHhlUqdi0=
MIME-Version: 1.0
In-Reply-To: <20100930132937.GA5728@localhost>
References: <Pine.LNX.4.64.1009302047410.25061@boston.corp.fedex.com>
	<20100930132937.GA5728@localhost>
Date: Thu, 30 Sep 2010 23:34:44 +0800
Message-ID: <AANLkTi=pdvGeLgcp8+Kwgu-o7BnYJ-ELKfq_8OTHrYqN@mail.gmail.com>
Subject: Re: Microphone not working on PCI ID 8086:3b56
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Takashi Iwai <tiwai@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Jaroslav Kysela <perex@perex.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 30, 2010 at 9:29 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:

> Intel HDMI audio selects SND_DYNAMIC_MINORS because it runs out of the
> static minor numbers. I initially proposed an extended static
> allocation scheme here:
> http://comments.gmane.org/gmane.linux.alsa.devel/72916 however the
> idea was rejected.
>
>> Do I really need udev to get mic to work?
>
> You can disable SND_HDA_CODEC_INTELHDMI for now. You don't need it.

Does not make sense to force everyone to use udev. Any chance to make
it work without udev?

Thanks,
Jeff
