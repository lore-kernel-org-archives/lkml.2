Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464Ab0IHG1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 02:27:24 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46729 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab0IHG1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 02:27:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=g+ig4YUzmjjrl6qAUTDPduzL3eiOevBdo7+ZhIP4UArC+k8P4hJ74mGjVAnCJhKjBZ
         abQJCetJTh0PqGTSw2yLe1UZ8BUkkcise65QxTlUuhOR4KclTRQCqz4kgY3QoFnbIO0U
         pY/aOQXi0JNhOFL69mNTnalj5X2PrfoqQhVWc=
MIME-Version: 1.0
In-Reply-To: <19F8576C6E063C45BE387C64729E739404687B2835@dbde02.ent.ti.com>
References: <1282241331-5178-1-git-send-email-pavan_savoy@ti.com>
	<4C6D6A9A.3010409@oracle.com>
	<19F8576C6E063C45BE387C64729E7394044F124F7B@dbde02.ent.ti.com>
	<4C6D6BCB.2090307@oracle.com>
	<AANLkTi==HVhXcS0Mxv4GJL1rB0nLc3YQ=b5RbzM0iFwG@mail.gmail.com>
	<20100822033248.GA4886@suse.de>
	<19F8576C6E063C45BE387C64729E7394046836CB57@dbde02.ent.ti.com>
	<20100831041114.GA16009@suse.de>
	<19F8576C6E063C45BE387C64729E7394046836CE5C@dbde02.ent.ti.com>
	<20100831224238.GA13253@suse.de>
	<19F8576C6E063C45BE387C64729E739404687B2835@dbde02.ent.ti.com>
Date: Wed, 8 Sep 2010 09:27:21 +0300
Message-ID: <AANLkTimCkTFfe157dHK=caAdAeX_4m1A_p6ZRxp=2RWt@mail.gmail.com>
Subject: Re: [PATCH] drivers:staging:ti-st: remove st_get_plat_device
From: Anca Emanuel <anca.emanuel@gmail.com>
To: "Savoy, Pavan" <pavan_savoy@ti.com>
Cc: Greg KH <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Build error (kernel 2.6.36-rc3-git1):


Building modules, stage 2.
  MODPOST 3056 modules
ERROR: "st_get_plat_device" [drivers/staging/ti-st/st_drv.ko] undefined!
