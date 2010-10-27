Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759003Ab0J0H4O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 03:56:14 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57576 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757527Ab0J0H4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 03:56:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=XGirQdMqzQ43wzcNa6IaiqDwEHnBcOigwPFnKU6/7mrg5pxwrP7SNqroUXUllZGdv4
         2fkueUNHH1C39DbQQOuOgD02wqG+s6XJmzgObDkROHhXoF7QfQhLniOGTDoe65vscs5d
         /CEukuhyW0ASNW7hss/igud5bobEgNIqzs1MM=
MIME-Version: 1.0
In-Reply-To: <002801cb758f$876aaf00$66f8800a@maildom.okisemi.com>
References: <4CC61B1B.3090602@dsn.okisemi.com>
	<20101026.105206.15244527.davem@davemloft.net>
	<002801cb758f$876aaf00$66f8800a@maildom.okisemi.com>
Date: Wed, 27 Oct 2010 17:56:11 +1000
Message-ID: <AANLkTi=bJTMhEo2agsMJ8fptNp7suERCGkzybb5m7ggg@mail.gmail.com>
Subject: Re: can: About Socket CAN with MSI issue
From: Dave Airlie <airlied@gmail.com>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        socketcan-core@lists.berlios.de, sameo@linux.intel.com,
        21cnbao@gmail.com, chripell@fsfe.org, w.sang@pengutronix.de,
        wg@grandegger.com, David Miller <davem@davemloft.net>,
        margie.foster@intel.com, kok.howg.ewe@intel.com, joel.clark@intel.com,
        andrew.chih.howe.khor@intel.com, yong.y.wang@intel.com,
        qi.wang@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 2:29 PM, Tomoya MORINAGA
<tomoya-linux@dsn.okisemi.com> wrote:
> We have faced issue when our CAN diriver whose MSI is enabled, after installing the driver,
> once remove the driver and install the driver again,
> As a result, interupt handler of the driver is not called again.
>
> Do you have any information or suggestion about the above issue?

Its a bug in the PCI layer most likely,

http://amailbox.org/mailarchive/linux-kernel/2010/10/7/4629072

Dave.
