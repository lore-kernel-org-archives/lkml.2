Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab0I3IgZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 04:36:25 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62116 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab0I3IgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 04:36:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ft6UaQ60yV5XoDj4w3ucOJXzF8M+66xkUozhAAioksQCm2A7ePOkr3Ho4ljHJDhPS6
         bCCayayXzd+UKF7cDRXzocsQx+gt/8vwf+CUadUgQslOZUqmnxpgqymKb0MQU+UL45+k
         7FI9MUZ7Rob59wMVcCddL0C5foxckApjj5GPI=
MIME-Version: 1.0
In-Reply-To: <1285835052-11880-1-git-send-email-arnd@arndb.de>
References: <1285835052-11880-1-git-send-email-arnd@arndb.de>
Date: Thu, 30 Sep 2010 10:36:21 +0200
Message-ID: <AANLkTi=cu4AHWzBn9zsb8SfzJ7-c+u0f8Lw2MNjF+BLL@mail.gmail.com>
Subject: Re: [PATCH 0/6] staging fixes
From: Belisko Marek <marek.belisko@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o8U8aXD4013604

On Thu, Sep 30, 2010 at 10:24 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> My previous version of the first patch (staging: make new
> character devices nonseekable) was untested and broke
> compilation in multiple ways.
>
> To make up for this, please take the fixed version
> and some patches to fix basic problems in those
> two drivers, as found by building with sparse.
Thanks for ft1000 patches. I'll test tomorrow when will have
ft1000 device available and let you know if there will be some regression.
Thanks for patches.
>
>        Arnd
>
> Arnd Bergmann (6):
>  staging: make new character devices nonseekable
>  stagin/ft1000-usb: fix unlocked_ioctl prototype
>  staging/ft1000-usb: fix build warnings
>  staging/ft1000-usb: fix problems found by sparse
>  staging/bcm: fix most build warnings
>  staging/bcm: add sparse annotations
>
>  drivers/staging/bcm/Adapter.h                      |    2 +-
>  drivers/staging/bcm/Bcmchar.c                      |  168 ++++++++++----------
>  drivers/staging/bcm/Bcmnet.c                       |    6 +-
>  drivers/staging/bcm/CmHost.c                       |   18 +-
>  drivers/staging/bcm/Debug.c                        |    2 +-
>  drivers/staging/bcm/HandleControlPacket.c          |    2 +-
>  drivers/staging/bcm/IPv6Protocol.c                 |    4 +-
>  drivers/staging/bcm/InterfaceDld.c                 |    6 +-
>  drivers/staging/bcm/InterfaceIdleMode.c            |    2 +-
>  drivers/staging/bcm/InterfaceIdleMode.h            |    2 +-
>  drivers/staging/bcm/InterfaceInit.c                |   31 ++--
>  drivers/staging/bcm/Ioctl.h                        |    8 +-
>  drivers/staging/bcm/LeakyBucket.c                  |   22 ++--
>  drivers/staging/bcm/Macros.h                       |    2 +-
>  drivers/staging/bcm/Misc.c                         |   20 ++-
>  drivers/staging/bcm/PHSDefines.h                   |    2 +-
>  drivers/staging/bcm/PHSModule.c                    |    2 +-
>  drivers/staging/bcm/Prototypes.h                   |    3 +-
>  drivers/staging/bcm/Qos.c                          |    8 +-
>  drivers/staging/bcm/Transmit.c                     |    4 +-
>  drivers/staging/bcm/led_control.c                  |   22 ++--
>  drivers/staging/bcm/nvm.c                          |   54 +++---
>  drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c   |   92 ++++++------
>  .../staging/ft1000/ft1000-usb/ft1000_download.c    |   45 +++---
>  drivers/staging/ft1000/ft1000-usb/ft1000_hw.c      |   95 +++++-------
>  drivers/staging/ft1000/ft1000-usb/ft1000_proc.c    |    2 +-
>  drivers/staging/ft1000/ft1000-usb/ft1000_usb.c     |   25 +---
>  drivers/staging/ft1000/ft1000-usb/ft1000_usb.h     |   43 +++++-
>  28 files changed, 348 insertions(+), 344 deletions(-)
>
>

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
icq: 290551086
web: http://open-nandra.com
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
