Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab0CRWIo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 18:08:44 -0400
Received: from mail-fx0-f219.google.com ([209.85.220.219]:34555 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688Ab0CRWIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 18:08:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=fS2lCycyK2rYa1rl6+xk19f2LOfAgkLE89vYTqzyb9ukug3ykzUWxZ6O+hkhDt7+Mv
         woi2jgXhKjd4wyq/9iLkEByOBSiDnJy45cfgJdEYbhnm/kTRwUd3Rop0U5UGBgi/nOJR
         x6NnzYSlini2QpqyHbiG6S/mJOWUBWoxsG4ks=
Message-ID: <4BA2A469.1090608@googlemail.com>
Date: Thu, 18 Mar 2010 23:08:41 +0100
From: =?ISO-8859-1?Q?Ren=E9_Bolldorf?= <xsecute@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] arch/x86/pci/legacy.c Section mismatch
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rene Bolldorf <xsecute@googlemail.com>

diff --git a/arch/x86/pci/legacy.c b/arch/x86/pci/legacy.c
index 8d460ea..c89266b 100644
--- a/arch/x86/pci/legacy.c
+++ b/arch/x86/pci/legacy.c
@@ -36,7 +36,7 @@ int __init pci_legacy_init(void)
  	return 0;
  }

-void pcibios_scan_specific_bus(int busn)
+void __devinit pcibios_scan_specific_bus(int busn)
  {
  	int devfn;
  	long node;
