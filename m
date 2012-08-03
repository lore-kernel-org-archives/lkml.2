Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab2HCQhW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 12:37:22 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:57679 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823Ab2HCQhR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 12:37:17 -0400
MIME-Version: 1.0
In-Reply-To: <20120803180712.1e768042@endymion.delvare>
References: <1344008145-14579-1-git-send-email-amaury.decreme@gmail.com> <20120803180712.1e768042@endymion.delvare>
From: =?UTF-8?Q?Amaury_Decr=C3=AAme?= <amaury.decreme@gmail.com>
Date: Fri, 3 Aug 2012 18:36:36 +0200
Message-ID: <CAPXEm73QX7haU5p7HU+=+qo5wnivt6j+WH5bQGZ0ZK0Ek2Cuyw@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] I2C: SIS964: Bus driver
To: Jean Delvare <khali@linux-fr.org>
Cc: ben-linux@fluff.org, w.sang@pengutronix.de, rob@landley.net,
        jeffrey.t.kirsher@intel.com, akpm@linux-foundation.org,
        davem@davemloft.net, gregkh@linuxfoundation.org, joe@perches.com,
        ralf@linux-mips.org, dirk.brandewie@gmail.com,
        jayachandranc@netlogicmicro.com, linux-i2c@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

>
> What is the rationale for not adding support for the new chip to
> i2c-sis630 then? That would probably be a lot easier to review.
>

I was afraid that adding SIS964 support to i2c-sis630 would lead
to confusion.

I can try to submit a patch for i2c-sis630. In this case, do you think
we should keep the 630 name or change it to something else to
avoid misunderstanding ?


>
> This split makes little sense. Integration should come with the driver,
> otherwise even build-testing is impossible.
>

Sorry for that. As the patch V1 was rather big, I was hesitating for
the same reason but posted it split. I'll "unsplit" for the V3 (unless
i2c-sis630 patch).


Amaury Decrême
