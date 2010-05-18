Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab0ERJpj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 05:45:39 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:50050 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab0ERJpg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 05:45:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hIAd98I18Hr9xDHvslUGrqB+9cMpG3djz5r46kYI7msD7l+/CAcMfQccqO/yZkoUOp
         q6QfG3lZGUrzX0r1X0EqYRwwtIjDX4+YHGUV1ykIXMb5+xarZNReVHXz8PTHTh/COPT9
         7ng/lZ8zIo2UCMEOSfI1Ci2kPEJmqp+YxbvkI=
MIME-Version: 1.0
In-Reply-To: <20100518092532.GA3050@linux-sh.org>
References: <20100518092532.GA3050@linux-sh.org>
Date: Tue, 18 May 2010 15:15:31 +0530
Message-ID: <AANLkTim6t8oG-vdLKE918Sd2TFKJpSf5Bw2PTtSsD_Fh@mail.gmail.com>
Subject: Re: [GIT PULL] sh updates for 2.6.35-rc1
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Paul,

On Tue, May 18, 2010 at 2:55 PM, Paul Mundt <lethal@linux-sh.org> wrote:
> Please pull from:
>
>        master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git
>
> Which contains:
>
..
>  drivers/dma/shdma.c                         |   52 ++-
>  drivers/dma/shdma.h                         |    4 +-
>  drivers/serial/sh-sci.c                     |  189 ++++++---
>  drivers/sh/Kconfig                          |   24 +
>  drivers/sh/Makefile                         |    2 +
>  drivers/sh/clk-cpg.c                        |  298 +++++++++++++
>  drivers/sh/clk.c                            |  545 ++++++++++++++++++++++
>  drivers/sh/intc.c                           |  333 +++++++++++++--
>  include/linux/device.h                      |    4 +
>  include/linux/serial_sci.h                  |    4 +-
>  include/linux/sh_clk.h                      |  150 +++++++
>  include/linux/sh_dma.h                      |  102 +++++
>  include/linux/sh_intc.h                     |   26 +-
..
>  create mode 100644 drivers/sh/Kconfig
>  create mode 100644 drivers/sh/clk-cpg.c
>  create mode 100644 drivers/sh/clk.c
>  create mode 100644 include/linux/sh_clk.h
>  create mode 100644 include/linux/sh_dma.h

I have few doubts :

1. Which other architectures are using :
include/linux/sh_clk.h, include/linux/sh_dma.h and include/linux/sh_intc.h

2. If you think, in future some architecture will going to use these
files, then do you think sh_*.h name is appropriate.

3. Can we move :
include/linux/sh_clk.h -> drivers/sh/sh_clk.h
include/linux/sh_dma.h -> drivers/dma/sh_dma.h
include/linux/sh_intc.h -> drivers/sh/sh_intc.h
So that if someone want to use these file they can use it from here.

Thanks,
--
Jaswinder Singh.
