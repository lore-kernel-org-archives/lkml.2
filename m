Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359Ab1AUNfG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 08:35:06 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53832 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab1AUNfE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 08:35:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iPaZWbEzUb5YeozVmcIG5k4j34HGzeOzYJu5fc3VJkpKQm48/QdZAIJFFYyn/MDVYK
         HgAiZoAmd2ovgY8F4SPCBksoknBDoH8qQLZ8iB/47LEK/B++xzLhPoM4w7+1DEeF+VsM
         MS4j1qzzPqcrxsgNmIzwsUH34EiMzgQanr6rM=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1101202147040.6236@ayla.of.borg>
References: <alpine.DEB.2.00.1101202147040.6236@ayla.of.borg>
Date: Fri, 21 Jan 2011 08:35:01 -0500
Message-ID: <AANLkTi=DVVFKS8SrtAprOUkC-Su3FYbkH918ByLm_vyD@mail.gmail.com>
Subject: Re: Build regressions/improvements in v2.6.38-rc1
From: Josh Boyer <jwboyer@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 3:47 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> Below is the list of build error/warning regressions/improvements in
> v2.6.38-rc1[1] compared to v2.6.37[2].
>
> Summarized:
>  - build errors: +96/-14
>  - build warnings: +142/-164
>
> In addition, I put the verbose summary at
> http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v2.6.38-rc1.summary.gz
> so you can easily find out for which configs and architectures the
> errors/warnings you're interested in are happening.
>
> Happy fixing! ;-)
>
> Thanks to the linux-next team for providing the build service.
>
> [1] http://kisskb.ellerman.id.au/kisskb/head/3649/ (all 108 configs)
> [2] http://kisskb.ellerman.id.au/kisskb/head/3595/ (all 108 configs)
>
>
> *** ERRORS ***
>        src/arch/powerpc/platforms/83xx/mpc831x_rdb.c: error: 'board' undeclared (first use in this function):  => 74
>        src/arch/powerpc/platforms/83xx/mpc831x_rdb.c: error: (Each undeclared identifier is reported only once:  => 74
>        src/arch/powerpc/platforms/83xx/mpc831x_rdb.c: error: expected '{' before 'const':  => 63
>        src/arch/powerpc/platforms/83xx/mpc831x_rdb.c: error: for each function it appears in.):  => 74

Grant should have this one fixed already.

josh
