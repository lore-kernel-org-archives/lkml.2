Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933896Ab0JSKDg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 06:03:36 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:58982 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932693Ab0JSKDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 06:03:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ea5unBEoARUtUEPOsk4We41AXx36InEdRDbrSGDkQy7Y6kZpNOeeFg3JMyp2DfMBx6
         PkHxt2BeojlIjri8QQvycgStpYMk14uz3qpdz7GJFkXfgWGOlEuKfL8pEm8tvlitJyjT
         llXD14159bmVSE5PPbgA4BeS1S4S/qw+3H+lc=
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-usb@vger.kernel.org, linux-omap <linux-omap@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>
Cc: Greg KH <greg@kroah.com>, Felipe Balbi <balbi@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH v2 0/3] usb: generic Kconfig fixes
Date: Tue, 19 Oct 2010 13:03:25 +0300
Message-Id: <1287482608-11320-1-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.7.3.1.2.g7fe2b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This gets rid of some warnings, makes defconfigs smarter by having more proper
dependencies, and general cleanups.

BTW, this is the reason USB_GADGET_MUSB_HDRC sometimes is not selected:
http://article.gmane.org/gmane.linux.kbuild.devel/5480

v2: comments by Felipe Balbi

Felipe Contreras (3):
  usb: fix Kconfig warning
  usb: trivial Kconfig cleanups
  drivers: cleanup Kconfig stuff

 drivers/mfd/Kconfig        |    3 ++-
 drivers/regulator/Kconfig  |    1 +
 drivers/usb/core/Kconfig   |    3 ---
 drivers/usb/gadget/Kconfig |   16 ++--------------
 drivers/usb/musb/Kconfig   |   23 ++++++-----------------
 drivers/usb/otg/Kconfig    |    2 ++
 6 files changed, 13 insertions(+), 35 deletions(-)

-- 
1.7.3.1.2.g7fe2b

