Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933677Ab1CaBFE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 21:05:04 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45883 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933055Ab1CaBFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 21:05:02 -0400
MIME-Version: 1.0
From: John Williams <john.williams@petalogix.com>
Date: Thu, 31 Mar 2011 11:04:39 +1000
Message-ID: <AANLkTi=Xp3cP-CPeQx-XO45fsZ38qu21fYeDz6rbLe+s@mail.gmail.com>
Subject: c67x00 gadget support?
To: linux-usb@vger.kernel.org
Cc: Peter Korsgaard <jacmet@sunsite.dk>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter K,

Back in April 2007 you posted a patch series that included a prototype
of gadget support for the c67x00.

http://www.spinics.net/lists/linux-usb-devel/msg04766.html

The host-side stuff is all merged, just wondering what, if anything,
became of the gadget layer?  It was some low level tweaks on
c67x00-drv.c but the majority was in c67x00-udc.[ch]

Thanks,

John
