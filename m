Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758833Ab0JFLOx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 07:14:53 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41334 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414Ab0JFLOw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 07:14:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=gHklx5GjQnW9AJYTUAOedjKfOGgo64m5PDBoXvqyi1OrRSVbpY+SQ1KFK7r5UQcFvE
         TUuGTHTlET9TyoUVIrZ5m4WmrWARpAN/SHGBROukvflwH06hAJ4N2k2A0L2V28Dphj8t
         s8G2G3PyBJe1A+z5gYZB8UMSHC5vcpjgkudPc=
MIME-Version: 1.0
In-Reply-To: <46AFBEB1-7026-4060-927C-ED1A0D84F8F7@mac.com>
References: <12E01E63-75E5-4822-BEA6-D8C0260BC915@mac.com>
	<AANLkTimqfHEYyErLiWfrW5SkjseTvcswoPOP2Jkab1pC@mail.gmail.com>
	<46AFBEB1-7026-4060-927C-ED1A0D84F8F7@mac.com>
Date: Wed, 6 Oct 2010 14:14:50 +0300
X-Google-Sender-Auth: _fPzX24apARRZj42p2FrGReO7BU
Message-ID: <AANLkTimWzD9350M4RFd+X9JrwiU_HxU9oyKqNjL-wuKZ@mail.gmail.com>
Subject: Re: How to test kernel drivers for memory leaks
From: Pekka Enberg <penberg@kernel.org>
To: Elvis Dowson <elvis.dowson@mac.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>, jason.wessel@windriver.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 6, 2010 at 1:13 PM, Elvis Dowson <elvis.dowson@mac.com> wrote:
>> Kmemleak is an in-kernel memory leak detector. See
>> Documentation/kmemleak.txt for details.
>
> Thanks for that info, I just read it and it looks useful.
>
> Do you know of any other tools that can be used for full static and dynamic analysis, and observations of variables while it is running on the target?
>
> I used to use Rational Test-Real-Time with a JTAG emulator probe before. Are there any other equivalent tools that can do good static and dynamic analysis of kernel modules, while it is running on the target, with a good interface?
>
> I want to setup a full kernel profiling and debug environment, to be able to debug linux kernel (android-2.6.32) running on a TI OMAP 3503 target platform (Gumstix Overo Earth), to optimize performance and improve the stability of the system (e.g. running for more than 1 year, without requiring a reboot).

I have never tried it myself but there's an in-kernel debugger in
mainline these days:

http://kernel.org/pub/linux/kernel/people/jwessel/kdb/

For profiling, I suggest you take a look at tools/perf in the mainline
source tree.

                        Pekka
