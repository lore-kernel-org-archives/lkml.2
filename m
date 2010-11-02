Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab0KBAOf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 20:14:35 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53056 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab0KBAOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 20:14:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=pbzVbv78zhok3498NVtqi2CYSp1Tz1oNCZF0ACbIOI8gRGOnmM1Qn9mqiAEVpNaNSK
         KsCVZJYqmX9Hly70zviDRnkFmUq2vn93u+FQ0j+dHh0gRs71rVC/n5ZhQzHaDRL+sClL
         PYlk0lMekLRyKbl532vX9URij7w2jjbBU8kr8=
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-usb <linux-usb@vger.kernel.org>
Cc: linux-main <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>, Felipe Balbi <balbi@ti.com>,
        Greg KH <greg@kroah.com>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH v3 0/2] usb: generic Kconfig fixes
Date: Tue,  2 Nov 2010 02:14:11 +0200
Message-Id: <1288656853-4625-1-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.7.3.2.2.g0dc5c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This gets rid of some warnings, makes defconfigs smarter by having more proper
dependencies, and general cleanups.

v3: comments by Roger Quadros, rebased to v2.6.37-rc1

Felipe Contreras (2):
  usb: trivial Kconfig cleanups
  drivers: cleanup Kconfig stuff

 drivers/mfd/Kconfig        |    2 +-
 drivers/regulator/Kconfig  |    1 +
 drivers/usb/core/Kconfig   |    3 ---
 drivers/usb/gadget/Kconfig |    7 +++----
 drivers/usb/musb/Kconfig   |   24 ++++++------------------
 drivers/usb/otg/Kconfig    |    2 ++
 6 files changed, 13 insertions(+), 26 deletions(-)

-- 
1.7.3.2.2.g0dc5c

