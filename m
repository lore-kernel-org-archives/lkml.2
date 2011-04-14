Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758707Ab1DNPMz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 11:12:55 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55915 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763Ab1DNPMx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 11:12:53 -0400
MIME-Version: 1.0
In-Reply-To: <1301630392-20793-1-git-send-email-bgat@billgatliff.com>
References: <1301630392-20793-1-git-send-email-bgat@billgatliff.com>
Date: Thu, 14 Apr 2011 10:12:51 -0500
Message-ID: <BANLkTik6Ftsy2yTA7LBKTUDJkqXPf4JeSA@mail.gmail.com>
Subject: Re: [PWM v9 0/3] Implement a generic PWM framework
From: Bill Gatliff <bgat@billgatliff.com>
To: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guys:


Anyone have any comment on this patch series?  Is it finally ready for Linus?

Thanks!


b.g.


On Thu, Mar 31, 2011 at 10:59 PM, Bill Gatliff <bgat@billgatliff.com> wrote:
> This patch series contains the ninth attempt at implementation of a
> generic PWM device interface framework.  Think gpiolib, but for
> devices and pseudo-devices that generate pulse-wave-modulated outputs.
>
> Compared to the previous version, this patch series:
>
>  * Fixes an unbalanced get_device()/put_device()
>
> A git tree containing these patches may be found here:
>
>    http://git.billgatliff.com/pwm.git
>
>
> Regards,
>
>
> b.g.
>
> Bill Gatliff (3):
>  PWM: Implement a generic PWM framework
>  PWM: GPIO+hrtimer device emulation
>  PWM: Atmel PWMC driver
>
>  Documentation/pwm.txt    |  276 ++++++++++++++++++++++
>  MAINTAINERS              |    8 +
>  drivers/Kconfig          |    2 +
>  drivers/Makefile         |    2 +
>  drivers/pwm/Kconfig      |   29 +++
>  drivers/pwm/Makefile     |    7 +
>  drivers/pwm/atmel-pwmc.c |  452 ++++++++++++++++++++++++++++++++++++
>  drivers/pwm/gpio-pwm.c   |  332 ++++++++++++++++++++++++++
>  drivers/pwm/pwm.c        |  580 ++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/pwm/pwm.h  |  143 ++++++++++++
>  10 files changed, 1831 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/pwm.txt
>  create mode 100644 drivers/pwm/Kconfig
>  create mode 100644 drivers/pwm/Makefile
>  create mode 100644 drivers/pwm/atmel-pwmc.c
>  create mode 100644 drivers/pwm/gpio-pwm.c
>  create mode 100644 drivers/pwm/pwm.c
>  create mode 100644 include/linux/pwm/pwm.h
>
> --
> 1.7.4.1
>
>



-- 
Bill Gatliff
bgat@billgatliff.com
