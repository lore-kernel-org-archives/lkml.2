Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab0LAJA2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 04:00:28 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:39857 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040Ab0LAJA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 04:00:27 -0500
Date: Wed, 1 Dec 2010 10:00:16 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Chethan Krishna N <chethan.krishna@stericsson.com>
Cc: guenter.roeck@ericsson.com, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, preetham.rao@stericsson.com,
        linus.walleij@linaro.org, mian-yousaf.kaukab@linaro.org
Subject: Re: [PATCH] lsm303dlh: Adding Accelerometer and Magnetometer
 support
Message-ID: <20101201100016.22b3ea0d@endymion.delvare>
In-Reply-To: <1291180447-16570-1-git-send-email-chethan.krishna@stericsson.com>
References: <1291180447-16570-1-git-send-email-chethan.krishna@stericsson.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  1 Dec 2010 10:44:07 +0530, Chethan Krishna N wrote:
> From: Chethan Krishna N <chethan.krishna@stericsson.com>
> 
> lsm303dlh accelerometer magnetometer device support added.
> Also provides input device support through interrupts.
> 
> Signed-off-by: Chethan Krishna N <chethan.krishna@stericsson.com>
> ---
>  drivers/hwmon/Kconfig       |   23 +
>  drivers/hwmon/Makefile      |    1 +
>  drivers/hwmon/lsm303dlh_a.c | 1112 +++++++++++++++++++++++++++++++++++++++++++
>  drivers/hwmon/lsm303dlh_m.c |  764 +++++++++++++++++++++++++++++
>  include/linux/lsm303dlh.h   |   56 +++
>  5 files changed, 1956 insertions(+), 0 deletions(-)
>  mode change 100644 => 100755 drivers/hwmon/Kconfig
>  create mode 100644 drivers/hwmon/lsm303dlh_a.c
>  create mode 100644 drivers/hwmon/lsm303dlh_m.c
>  create mode 100644 include/linux/lsm303dlh.h

Nack. This isn't a hardware monitoring driver, so it has nothing to do
in drivers/hwmon. Please find a better place.

-- 
Jean Delvare
