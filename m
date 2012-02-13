Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab2BMHZG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 02:25:06 -0500
Received: from webbox1416.server-home.net ([77.236.96.61]:42161 "EHLO
	webbox1416.server-home.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752792Ab2BMHZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 02:25:04 -0500
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>,
        Feng Tang <feng.tang@intel.com>,
        Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c-eg20t: Rework pch_i2c_wait_for_bus_idle to reduce wait time
Date: Mon, 13 Feb 2012 08:25 +0100
Message-ID: <63318173.mcCRrit7Mu@ws-stein>
User-Agent: KMail/4.7.4 (Linux/3.2.1-gentoo-r2; KDE/4.7.4; x86_64; ; )
In-Reply-To: <CANKRQniXxZbY5Bs90v+xsU3PRU6JntXF53Vv0Yhx0Lyhn3fq6g@mail.gmail.com>
References: <1328776366-6881-1-git-send-email-alexander.stein@systec-electronic.com> <CANKRQniXxZbY5Bs90v+xsU3PRU6JntXF53Vv0Yhx0Lyhn3fq6g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 10. Februar 2012, 09:52:03 schrieb Tomoya MORINAGA:
> 2012/2/9 Alexander Stein <alexander.stein@systec-electronic.com> wrote:
> >
> >        if ((ioread32(p + PCH_I2CSR) & I2CMBB_BIT) == 0)
> >                return 0;
> >
> 
> If this patch will be accepted,
> this code also looks redundant code.

Yep, you're right. I'll prepare a now patch after some days of possibly more comments.

Best regards,
Alexander
-- 
Dipl.-Inf. Alexander Stein

SYS TEC electronic GmbH
August-Bebel-Str. 29
D-07973 Greiz

Tel: +49-3661-6279-0, Fax: +49-3661-6279-99
eMail:    Alexander.Stein@systec-electronic.com
Internet: http://www.systec-electronic.com

Managing Director: Dipl.-Phys. Siegmar Schmidt
Commercial registry: Amtsgericht Jena, HRB 205563
