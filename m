Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab1JXVbc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 17:31:32 -0400
Received: from fmmailgate05.web.de ([217.72.192.243]:46167 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355Ab1JXVba convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 17:31:30 -0400
Date: Mon, 24 Oct 2011 23:31:29 +0200 (CEST)
From: "Roland Kletzing" <devzero@web.de>
To: "Wolfram Sang" <w.sang@pengutronix.de>, dedekind1@gmail.com
Cc: "Willy Tarreau" <w@1wt.eu>, adrian.hunter@intel.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Message-ID: <1410459321.1756342.1319491889412.JavaMail.fmail@mwmweb015>
Subject: Re: [BUG] Re: mtd_stresstest module bricked my dockstar
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Priority: 3
Importance: normal
Sensitivity: Normal
X-Provags-ID: V01U2FsdGVkX1/0rsOgPW8B2zza/AXSvl/5O9gWK9qP165Uy7YZCnLFA+9OqIe9siMU
 xHzycknOvGwsrxIAYPwC1w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> > Anyway - what would people think if linux had a kernel module which wipes
>> > /dev/sda1 when loaded ? :)
>
>Yeah, the tests are destructive and they start erasing and torturing
>your MTD device without preserving your data.
>
>And the bad thing is - if you do not pass any parameter, they will
>torture your mtd0.
>
>I am sorry that you bricked your device and I hope you will be able to
>resurrect it.

That will be an exercise....

>This was an oversight. The tests were written for
>validating new drivers and making sure they are robust. So we always
>assumed people run them on a development HW, not on a production HW.
>That was a false implicit assumption.

No problem, i think it will not beggar me. I was a little bit disappointed at 
first, but when re-thinking i think it`s just a result of some carelessnes 
of me (as the user) and also of you developers of that modules (as nobody
expected that it could be accidentally loaded or even exist because of some
foreign kernel .config). nice to see the positive reaction on my report.

>Yes, we should use -1 as the default value, and print a scary warning
>message when the module is inserted without a parameter. We should
>probably also put word "destructive" or something like this to the
>module description.

Great! That sounds good. I think i will happily test if a fix is working, but
most likely not on my other Dockstar. Maybe block2mtd on top of a file-backed
loopdevice will provide a safe test-environment on my x86 box..... :)

regards
Roland


___________________________________________________________
SMS schreiben mit WEB.DE FreeMail - einfach, schnell und
kostenguenstig. Jetzt gleich testen! http://f.web.de/?mc=021192
