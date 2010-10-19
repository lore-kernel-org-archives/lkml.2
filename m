Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933684Ab0JSIEj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 04:04:39 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33857 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933090Ab0JSIEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 04:04:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=sz6uGkBmeobpNQ84sGdYGqktPmLwOolXVWfuBZnIspj1wSTkYOyJzKqRmVx1RtPiQZ
         uR1dRT4jtEl/FRJyBO9RCLZwl5wZtJl+fYRcW1+w5GvUxmp9ESlPX294T6XVKpUrFCBK
         hgCuITlK1dPHBnZ/Y5BkCYUEX94OKtlka0SFU=
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-usb@vger.kernel.org, linux-main <linux-kernel@vger.kernel.org>
Cc: Greg KH <greg@kroah.com>, Felipe Balbi <balbi@ti.com>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH 0/3] usb: geneirc Kconfig fixes
Date: Tue, 19 Oct 2010 11:04:23 +0300
Message-Id: <1287475466-8927-1-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.7.3.1.2.g7fe2b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This gets rid of some warnings, makes defconfigs smarter by having more proper
dependencies, and general cleanups.

BTW, this is the reason USB_GADGET_MUSB_HDRC sometimes is not selected:
http://article.gmane.org/gmane.linux.kbuild.devel/5480

Felipe Contreras (3):
  usb: fix Kconfig warning
  usb: trivial Kconfig cleanups
  drivers: cleanup Kconfig stuff

 drivers/mfd/Kconfig        |    4 +++-
 drivers/usb/core/Kconfig   |    3 ---
 drivers/usb/gadget/Kconfig |   18 +++---------------
 drivers/usb/musb/Kconfig   |   19 +++++--------------
 4 files changed, 11 insertions(+), 33 deletions(-)

-- 
1.7.3.1.2.g7fe2b

