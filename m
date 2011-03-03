Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724Ab1CCGvT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 01:51:19 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:47079 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab1CCGvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 01:51:18 -0500
Message-ID: <8D0A8E9498DC4424BEA50A1B950A05FE@minx0099669>
From: "Pavan Savoy" <pavan_savoy@ti.com>
To: "Greg KH" <greg@kroah.com>
Cc: <linux-kernel@vger.kernel.org>, <gregkh@suse.de>
References: <1299059996-21267-1-git-send-email-pavan_savoy@ti.com> <20110303040605.GA26776@kroah.com>
Subject: Re: [PATCH] drivers:misc: ti-st: fix debugging code
Date: Thu, 3 Mar 2011 12:34:17 +0530
Organization: mindtree ltd.
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5843
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>What tree was this made against?  I can't seem to apply it to my
>staging-next tree.
>confused,

Made against linux-next as usual.
However I see that your staging-next has these for drivers/misc/ti-st/

73f12e8d3d94828b9efe2b8b8a34b4ad6d14ee47 drivers: misc: ti-st: fix review comments
2bb32e84a17fab547c7a746c7888e846c9cd88cc misc: ti-st: Kconfig & Makefile for TI_ST
a0cc2f3b51a8649da5262aba7501dc21738e1b8d staging: ti-st: move TI_ST from staging to misc/

and the linux-next has these for drivers/misc/ti-st/

bb6a7d53d52ec5b574467c48159677904d34a56a drivers:misc: ti-st: fix debugging code
781a7395d239dbdb59738ca7fe08e71641bf583c drivers:misc: ti-st: remove multiple gpio handling
6d71ba2105a1d8c1712cdfcf46fc6040e4707cb9 drivers:misc: ti-st: fix hci-ll on wake_ind collision
ef04d121f030329aae0c2d3ec22beea0c5cbcfd3 drivers:misc: ti-st: firmware download optimization
6710fcff66ef0330cdc458557271ee86026745d0 drivers:misc: ti-st: set right debug levels for logs
704426649dd4324b34cefea322f4333e5280f852 drivers:misc: ti-st: fix error codes
ec60d0ad20ff8796dc41b30a9dce485478ccd263 drivers:misc: ti-st: move from rfkill to sysfs
5c88b02196a99332dacf305c8757674dd7a303ff drivers:misc: ti-st: register with channel IDs
73f12e8d3d94828b9efe2b8b8a34b4ad6d14ee47 drivers: misc: ti-st: fix review comments
2bb32e84a17fab547c7a746c7888e846c9cd88cc misc: ti-st: Kconfig & Makefile for TI_ST
a0cc2f3b51a8649da5262aba7501dc21738e1b8d staging: ti-st: move TI_ST from staging to misc/

So, I am not sure how the 8 patches on top of "drivers: misc: ti-st: fix review comments" made it to linux-next without making to 
staging-next ....
when I received the automated mail of these 8 patches I got the tree link as
"git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core-2.6.git" unlike the usual staging-next !!

So make be you should apply them on driver-core-2.6 ?
Can you help me understand the flow ?

>greg k-h

