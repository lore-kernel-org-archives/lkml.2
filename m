Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758822Ab2BJAwJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 19:52:09 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38738 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758786Ab2BJAwD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 19:52:03 -0500
MIME-Version: 1.0
In-Reply-To: <1328776366-6881-1-git-send-email-alexander.stein@systec-electronic.com>
References: <1328776366-6881-1-git-send-email-alexander.stein@systec-electronic.com>
Date: Fri, 10 Feb 2012 09:52:03 +0900
Message-ID: <CANKRQniXxZbY5Bs90v+xsU3PRU6JntXF53Vv0Yhx0Lyhn3fq6g@mail.gmail.com>
Subject: Re: [PATCH] i2c-eg20t: Rework pch_i2c_wait_for_bus_idle to reduce
 wait time
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Alexander Stein <alexander.stein@systec-electronic.com>
Cc: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>,
        Feng Tang <feng.tang@intel.com>,
        Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/2/9 Alexander Stein <alexander.stein@systec-electronic.com> wrote:
>
>        if ((ioread32(p + PCH_I2CSR) & I2CMBB_BIT) == 0)
>                return 0;
>

If this patch will be accepted,
this code also looks redundant code.

thanks,
tomoya
