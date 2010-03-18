Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab0CRWIt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 18:08:49 -0400
Received: from mail-fx0-f219.google.com ([209.85.220.219]:34555 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688Ab0CRWIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 18:08:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=toXOBq/2rEvbdwXyzWge7GTT3IPi+IbCpvQ9SHbTKAY94hW5izhY75DAZYiP4C97su
         oH/BcRowseMBh9P1xDcXJSFRWI/eOT75FTw7YKo8dQza3ctPYbUCBfcgpcjIlljlsbEv
         Xfwfh/sf+4D4cgnxrS9785sw7gZ2tSJT/OptE=
Message-ID: <4BA2A46E.5090008@googlemail.com>
Date: Thu, 18 Mar 2010 23:08:46 +0100
From: =?ISO-8859-1?Q?Ren=E9_Bolldorf?= <xsecute@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] drivers/pci/pci.c Section mismatch
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rene Bolldorf <xsecute@googlemail.com>

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index ddd55dc..a1f7d93 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2773,7 +2773,7 @@ int pci_resource_bar(struct pci_dev *dev, int 
resno, enum pci_bar_type *type)
  /* Some architectures require additional programming to enable VGA */
  static arch_set_vga_state_t arch_set_vga_state;

-void __init pci_register_set_vga_state(arch_set_vga_state_t func)
+void pci_register_set_vga_state(arch_set_vga_state_t func)
  {
  	arch_set_vga_state = func;	/* NULL disables */
  }
