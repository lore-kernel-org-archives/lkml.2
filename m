Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238Ab0JANit (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 09:38:49 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60495 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756274Ab0JANis convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 09:38:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=NZuTPoYNBLov/KUTYW7h2u0KPYsu6I0Gp4P8P7OFnH7O12Cu+1Kgr02Sv+kEPZdoba
         g7VCXEj4eLVpi6YhpYF+bf7UcA1un+oF0rVVAy+jmvEhW7zhOWqDp6jWZ+rmGONGECJX
         oCG0JNyj75w6jrZ1pVMaSNOgojvCP9QRoU6qw=
MIME-Version: 1.0
In-Reply-To: <20101001140619.28d96040@endymion.delvare>
References: <20101001140619.28d96040@endymion.delvare>
Date: Fri, 1 Oct 2010 22:38:46 +0900
X-Google-Sender-Auth: f_yAJhU8tYCs9yGEGMBE9KDpY5Y
Message-ID: <AANLkTi=aKWP3_KhD88ebGB04xAM9Pc7eqw1LBr2EJNS_@mail.gmail.com>
Subject: Re: [GIT PULL] i2c fixes for 2.6.36
From: Kyungmin Park <kmpark@infradead.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

Even though it's not yet acked from Ben. It should be fixed for
correct operation.
Without this patch, some I2C device doesn't work correctly.
http://www.spinics.net/lists/linux-i2c/msg04016.html

Thank you,
Kyungmin Park

On Fri, Oct 1, 2010 at 9:06 PM, Jean Delvare <khali@linux-fr.org> wrote:
> Hi Linus,
>
> Please pull i2c subsystem fixes for Linux 2.6.36 from:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git i2c-for-linus
>
>  drivers/i2c/busses/i2c-cpm.c           |    5 +++
>  drivers/i2c/busses/i2c-ibm_iic.c       |    3 ++
>  drivers/i2c/busses/i2c-mpc.c           |    1 +
>  drivers/i2c/busses/i2c-pca-isa.c       |   12 +++++--
>  drivers/i2c/busses/i2c-pca-platform.c  |   11 ++++--
>  drivers/i2c/i2c-core.c                 |   54 ++++++++++++++-----------------
>  drivers/misc/bh1780gli.c               |    1 -
>  drivers/regulator/ad5398.c             |    1 -
>  drivers/regulator/isl6271a-regulator.c |    2 -
>  drivers/rtc/rtc-ds3232.c               |    2 -
>  10 files changed, 48 insertions(+), 44 deletions(-)
>
> ---------------
>
> Grant Likely (1):
>      of/i2c: Fix module load order issue caused by of_i2c.c
>
> Rajendra Nayak (1):
>      i2c: Fix checks which cause legacy suspend to never get called
>
> Vishwanath BS (1):
>      i2c: Fix for suspend/resume issue
>
> Wolfram Sang (1):
>      i2c: Remove obsolete cleanup for clientdata
>
> Yegor Yefremov (1):
>      i2c-pca: Fix waitforcompletion() return value
>
> Thanks,
> --
> Jean Delvare
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
