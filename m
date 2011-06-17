Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759239Ab1FQP4y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 11:56:54 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57464 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab1FQP4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 11:56:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=chcp+7qunSvNw4YA0C3AD2JuWCeYwCreTKwA/BjsSIXvERZnumPq9O8IPH1nOWqxXw
         NZswp+nrE+gN3vQtJMIe0wac5jEDCvvHXVvPUHX6JaH2bhbQ4UhzOy9kBdtG++kBEq29
         HdRrr4bWTt4Q8iVN3W8uLYl/q0eEhGe10O1W0=
MIME-Version: 1.0
In-Reply-To: <4DFB53B3.8070806@ladisch.de>
References: <20110617103218.GA29723@opensource.wolfsonmicro.com>
 <1308310831-27861-1-git-send-email-lars@metafoo.de> <4DFB53B3.8070806@ladisch.de>
From: Mike Frysinger <vapier@gentoo.org>
Date: Fri, 17 Jun 2011 11:56:29 -0400
X-Google-Sender-Auth: umPXqLqOGj3keYH1vFjDwOqccKQ
Message-ID: <BANLkTimWfT_LSLX36oLcSSYNqi4buBiJUQ@mail.gmail.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 09:16, Clemens Ladisch wrote:
> It looks as if sigma.c doesn't actually belong into drivers/firmware.
> That directory is for code that lets the kernel access the firmware
> of the platform that the kernel itself runs on.

-EMISSINGBETTERSUGGESTION

> The request_firmware() stuff is usually part of the actual driver that
> needs it.

except for when the firmware format is the same across many drivers
because it has a unified format (by design)
-mike
