Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260Ab2LSHuP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 02:50:15 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:39732 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab2LSHuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 02:50:11 -0500
X-Greylist: delayed 1401 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Dec 2012 02:50:11 EST
MIME-Version: 1.0
X-Originating-IP: [85.250.89.0]
In-Reply-To: <1355928677.1839.9.camel@cliu38-desktop-build>
References: <1355928677.1839.9.camel@cliu38-desktop-build>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 19 Dec 2012 09:18:26 +0200
Message-ID: <CAK=WgbYM6hbYGHupLOfdgg457qSjur7=PteO--Lnzgh-14pkfw@mail.gmail.com>
Subject: Re: [PATCH] mmc: sdio: Removing the unnecessary runtime_get/put in sdio_bus_remove()
To: Chuansheng Liu <chuansheng.liu@intel.com>
Cc: Chris Ball <cjb@laptop.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 4:51 PM, Chuansheng Liu
<chuansheng.liu@intel.com> wrote:
>
> The runtime_get_sync() is called during sdio_bus_probe(), then the device
> will be kept in active runtime state

Unless, of course, the driver powered it down.

>, so not neccessary to call
> runtime_get_sync/put_noidle() again in sdio_bus_remove().

See comment above...
