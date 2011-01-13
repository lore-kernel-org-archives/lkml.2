Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832Ab1AMS5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 13:57:31 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:34158 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab1AMS53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 13:57:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=UxDfYUdKiUFzRWuUv4VmRvHPo1yNX+tq7ArPzB019vJBbkwLBmu2+4OuZfUWjMcSuS
         h1jDj73ABwVee+16k15qEhJW57JA8Mfajny0me53iiJDi2XmzGYTi4MYmwy8NP+G8Idk
         hAJ1zCfQ7LlQjEo3M05Jg8i9pFQxs+Op4mWjw=
MIME-Version: 1.0
In-Reply-To: <20110113183025.GE2006@aftab>
References: <1294934542-2411-1-git-send-email-manoj.iyer@canonical.com>
	<1294934542-2411-2-git-send-email-manoj.iyer@canonical.com>
	<20110113164616.GB21289@srcf.ucam.org>
	<alpine.LFD.2.00.1101131808450.2678@localhost6.localdomain6>
	<20110113172205.GA30866@kryptos.osrc.amd.com>
	<AANLkTinw23rtSERxAy6G_cu5=rvQeEzxvf3snsUOZE+z@mail.gmail.com>
	<20110113175531.GD2006@aftab>
	<AANLkTikDoRMoQjtN03eMoeacwottEixrFqcF8nJZWgKy@mail.gmail.com>
	<20110113183025.GE2006@aftab>
Date: Thu, 13 Jan 2011 12:57:28 -0600
X-Google-Sender-Auth: 5fduAEG9UlsBN-hLqRyNdFF8QZM
Message-ID: <AANLkTi=RS8jRiQOnVuvNLS4TnNvzDc2S8QytN0gxD+SQ@mail.gmail.com>
Subject: Re: [PATCH] Quirk to fix suspend/resume on Lenovo Edge 11,13,14,15
From: Manoj Iyer <manoj.iyer@canonical.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Matthew Garrett <mjg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Thanks, that looks better. A stab in the dark:
>
> Can you boot your machine with "nohpet" and try a suspend/resume cycle
> to see whether that helps?

with nohpet in the kernel command line the system was able to resumes
from suspend normally.

>
> If that works, can you then boot normally (i.e. no "nohpet" option on
> the command line) and wait ~5mins after resume to see whether your
> machine comes out of the hang after all (the idea here is to wait for
> the 32bit HPET counter to wrap around).

And, yes, with "nohpet", the system comes back from hang after
approximately 5 minutes.

>
> Thanks.
>
> --
> Regards/Gruss,
> Boris.
>
> Advanced Micro Devices GmbH
> Einsteinring 24, 85609 Dornach
> General Managers: Alberto Bozzo, Andrew Bowd
> Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
> Registergericht Muenchen, HRB Nr. 43632
>



-- 
--manjo
