Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839Ab2GPVvk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 17:51:40 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:55524 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337Ab2GPVvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 17:51:38 -0400
X-Greylist: delayed 403 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Jul 2012 17:51:37 EDT
Date: Mon, 16 Jul 2012 23:44:53 +0200
From: Andreas Mohr <andi@lisas.de>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: psmouse synaptics: "hardware appears to be different" bail out
Message-ID: <20120716214453.GA14785@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

just found the following in dmesg after resume
(currently running -rc7):

[ 9312.672073] psmouse serio2: synaptics: hardware appears to be
different: id(149271-149271), model(114865-114865), caps(d04771-d04773),
ext(a40000-a40000).

Acer Aspire One A110L here.

Any clever thoughts about this?
Just thought that it might be useful to report it,
especially since the function (in drivers/input/mouse/synaptics.c)
bails out right after this check/message.

Thanks,

Andreas Mohr
