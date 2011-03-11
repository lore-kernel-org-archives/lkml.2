Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076Ab1CKP4I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 10:56:08 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:37776 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755838Ab1CKP4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 10:56:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Nx07/2n+EXdVSdFT5amfxe/LxTnVMx7L8yW3KDg9LkZalrb3r3OCC2DU3QcGJwF1+N
         /CVJCuTsPoM1D2riVJPZK03NDzoswyN1T3VcOxOXBUAyy2zx+gvLbwIJpczt/AkW7nQn
         neyOWnKK809dqRPzSlBe7QHUgTtMqthuu/kdg=
MIME-Version: 1.0
In-Reply-To: <201103111247.00212.trenn@suse.de>
References: <201103111247.00212.trenn@suse.de>
Date: Fri, 11 Mar 2011 15:56:01 +0000
Message-ID: <AANLkTimFg+uYGbSi=Ci-+_e89TgLkyMB7PAJcnt7mzTc@mail.gmail.com>
Subject: Re: [ANNOUNCE] cpupowerutils - cpufrequtils extended with quite some features
From: Corentin Chary <corentin.chary@gmail.com>
To: Thomas Renninger <trenn@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, discuss@lesswatts.org,
        power@bughost.org, cpufreq@vger.kernel.org, linux@dominikbrodowski.net,
        Mattia Dongili <malattia@linux.it>, Len Brown <lenb@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, herrmann.der.user@googlemail.com,
        linux-omap@vger.kernel.org, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 11:46 AM, Thomas Renninger <trenn@suse.de> wrote:
> Why is there need for another tool?
> -----------------------------------
>
> CPU power consumption vs performance tuning is not about
> CPU frequency switching anymore for quite some time.
> Deep sleep states, traditional dynamic frequency scaling and
> hidden turbo/boost frequencies are tight close together and
> depend on each other. The first two exist on different architectures
> like PPC, Itanium and ARM the latter only on X86.
> On X86 the APU (CPU+GPU) will only run most efficiently if CPU
> and GPU has proper power management in place.
>
> Users and Developers want to have *one* tool to get an overview what their
> system supports and to monitor and debug CPU power management in detail.
>
> The tool should compile and work on as much architectures as
> possible.
>

Hi Thomas,
Do you think handling really vendor specific "boosts" like EeePC's SHE
is in cpupower scope ?
Still, it would not solve the issue of setting SHE mode in a standard
way, or associating it with a governor.
Thanks,

-- 
Corentin Chary
http://xf.iksaif.net
