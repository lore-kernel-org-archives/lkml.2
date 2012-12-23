Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710Ab2LWJW2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 04:22:28 -0500
Received: from mga11.intel.com ([192.55.52.93]:27381 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520Ab2LWJWY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 04:22:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,341,1355126400"; 
   d="scan'208";a="269047896"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        "Greg KH (gregkh@linuxfoundation.org)" <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ldv-project@linuxtesting.org" <ldv-project@linuxtesting.org>
Subject: RE: [PATCH] mei: fix mismatch in mutex unlock-lock in
 mei_amthif_read()
Thread-Topic: [PATCH] mei: fix mismatch in mutex unlock-lock in
 mei_amthif_read()
Thread-Index: AQHN38Rz9RQDM8eICUm/XjeDey1YtpgmHUFw
Date: Sun, 23 Dec 2012 09:22:19 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B01EA990D@HASMSX106.ger.corp.intel.com>
References: <1356126256-21389-1-git-send-email-khoroshilov@ispras.ru>
In-Reply-To: <1356126256-21389-1-git-send-email-khoroshilov@ispras.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> 
> Users of mei_amthif_read() expect it leaves dev->device_lock held, while
> there is a path where mei_amthif_read() unlocks device_lock and returns -
> ERESTARTSYS.
> 
> The patch move code locking device_lock back before the return.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Acked-by:   Tomas Winkler <tomas.winkler@intel.com>

Greg.  This should be eligible for 3.8.

Thanks
Tomas


