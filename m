Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab0FRSiq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 14:38:46 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:62519 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730Ab0FRSin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 14:38:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=NrPHWdJfeCfIjak9+Yl4OIvuBoPRGDGkKEiVfTs+4Wv5JmzB6wEFyJsyQvmkTFf0nx
         lapzbWjAeosMuY3mbIvEXuZBMW00uvZ/XfF/q3hyCgig/86dPWcwRg/vP+mdBBM/uMLi
         VzrL9LBpmHijhszoU7hIt67vSBcmkZKkzZRUk=
Message-ID: <4C1BBD31.8010609@gmail.com>
Date: Fri, 18 Jun 2010 11:38:41 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 4/5]pci:setup_bus.c Fix warning: variable 'retval' set
 but not used
References: <1276666434-11227-1-git-send-email-justinmattock@gmail.com>	<1276666434-11227-5-git-send-email-justinmattock@gmail.com> <20100618102330.29eccb5b@virtuousgeek.org>
In-Reply-To: <20100618102330.29eccb5b@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From b07231ddb853e9388cea77a82da210e36ab79aad Mon Sep 17 00:00:00 2001
From: Justin P. Mattock <justinmattock@gmail.com>
Date: Fri, 18 Jun 2010 11:32:20 -0700
Subject: [PATCH 2/2] setup-bus_test
  Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
  drivers/pci/setup-bus.c |    1 +
  1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 19b1113..7b57dd0 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -875,6 +875,7 @@ again:
  	pci_bus_size_bridges(parent);
  	__pci_bridge_assign_resources(bridge, &head);
  	retval = pci_reenable_device(bridge);
+	printk(KERN_DEBUG "PCI%d: re-enabling device\n", retval);
  	pci_set_master(bridge);
  	pci_enable_bridges(parent);

-- 
1.7.1.rc1.21.gf3bd6


o.k. I went through this as you had requested to the best of my 
knowledge(bit confused with this, but will try).

let me know if more should be added and/or it's totally wrong
then I'll try again until correct..

Justin P. Mattock
