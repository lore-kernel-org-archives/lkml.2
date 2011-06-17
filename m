Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932405Ab1FQSZp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 14:25:45 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41732 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932107Ab1FQSZm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 14:25:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=XCMdJZnT8oy5ZEI5j2G5Rt3969IIojgJIKMQb8EWikD+NlWHLDdDDBsa3jdPIFpB5Z
         Qq8w9lPKcoQR1vy2LZ1b84BDa3NRZZgusl6/vfnkjgweWXIKPU63Axg5YrCCfEyoHnku
         d2BJYFebYADXJVS2bT937biWC9wIFmxt/efFk=
MIME-Version: 1.0
In-Reply-To: <4DFB98EE.9000609@ladisch.de>
References: <20110617103218.GA29723@opensource.wolfsonmicro.com>
 <1308310831-27861-1-git-send-email-lars@metafoo.de> <4DFB53B3.8070806@ladisch.de>
 <BANLkTimWfT_LSLX36oLcSSYNqi4buBiJUQ@mail.gmail.com> <4DFB98EE.9000609@ladisch.de>
From: Mike Frysinger <vapier@gentoo.org>
Date: Fri, 17 Jun 2011 14:25:21 -0400
X-Google-Sender-Auth: tUX5XzY312PO2oRpOTOJrL8btOE
Message-ID: <BANLkTi=idGOgMkBXF6p-Uo9ARAmgb1uR_g@mail.gmail.com>
Subject: Re: [PATCH] firmware: Make firmware drivers generally available
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 14:11, Clemens Ladisch wrote:
> Mike Frysinger wrote:
>> On Fri, Jun 17, 2011 at 09:16, Clemens Ladisch wrote:
>> > It looks as if sigma.c doesn't actually belong into drivers/firmware.
>> > That directory is for code that lets the kernel access the firmware
>> > of the platform that the kernel itself runs on.
>>
>> -EMISSINGBETTERSUGGESTION
>
> I *knew* somebody would ask.  :)
>
> "drivers/firmware" is the obvious name for both, but that makes
> it ambiguous.  I'd suggest to split the two subsystems into
> "drivers/host-firmware" and "drivers/device-firmware".

i honestly dont see how this is better.  the drivers/firmware/ isnt
exactly overflowing, and differentiating between the two modes doesnt
seem to gain us anything.
-mike
