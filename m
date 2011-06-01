Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163024Ab1FAIhW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:37:22 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39671 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161791Ab1FAIhS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:37:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=xVr6kW5P8T7aqerS030n67n3+HVRQsnWd/fhKjkhU0fsiGo6Aq4AJJuzh/uFdc+Edi
         FVHgXPhenP3QkK/9KirHpnc0zyGDa6GqBmPxSKjF+RL45yoYIRq5NsqB9HUYRPF9F3Ux
         vOgbNwmggQ2/wVUxxU6iggxDZxSyxtmk63OhU=
MIME-Version: 1.0
In-Reply-To: <20110601083000.GD3660@n2100.arm.linux.org.uk>
References: <1306830661-9546-1-git-send-email-mattias.wallin@stericsson.com>
	<alpine.LFD.2.02.1105311236250.3078@ionos>
	<4DE51EB7.7010606@stericsson.com>
	<BANLkTinPKbUu40066+wr3cdFRc2di-Uv6g@mail.gmail.com>
	<20110601083000.GD3660@n2100.arm.linux.org.uk>
Date: Wed, 1 Jun 2011 10:37:16 +0200
X-Google-Sender-Auth: T6QJZgZSIdKMCJ_fICqjdC1EDtU
Message-ID: <BANLkTimAOWNJNGJwJkCkwwDJ2BR__NCV+A@mail.gmail.com>
Subject: Re: [PATCH 2/3] clocksource: add DB8500 PRCMU Timer support
From: Linus Walleij <linus.walleij@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>, Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mattias Wallin <mattias.wallin@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/1 Russell King - ARM Linux <linux@arm.linux.org.uk>:
> On Tue, May 31, 2011 at 11:18:25PM +0200, Linus Walleij wrote:
>> Keeping it under include/linux is probably wise since we want drivers
>> OUT of the ARM tree, but I don't know if there is much consensus on that?
>
> Header files private to a driver should be alongside the driver.  Look
> at drivers/net or drivers/scsi for plenty of examples.
>
> Just because its a header file does not mean it must be in some directory
> with 'include' in its path.  The only reason to put it in include/linux
> is if it contains stuff which needs to be shared outside of the driver
> (eg, with arches).

I agree. Right now I have a creepy feeling that many drivers are just
putting headers in <mach/foo.h> out of habit, when plain "foo.h" in
working dir or <linux/subsystem/foo.h> is what is really apropriate.

Yours,
Linus Walleij
