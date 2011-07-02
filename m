Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab1GBQnm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 12:43:42 -0400
Received: from smtp-out.google.com ([74.125.121.67]:46171 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442Ab1GBQnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 12:43:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding;
	b=oZO7Ng79MdVZLe8hAVjXv0zEoeOjYh30IxzTdLzoHQw9quXjdF603FsClq7iIC8Ux
	Bkk+Xp/gohSdLmYcmLA0A==
Subject: [PATCH] Series short description
To: Wim Van Sebroeck <wim@iguana.be>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org
Date: Sat, 02 Jul 2011 10:43:35 -0600
Message-ID: <20110701212404.25544.84384.stgit@bhelgaas.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series implements...

---

Bjorn Helgaas (1):
      x86/PCI: reduce severity of host bridge window conflict warnings


 arch/x86/pci/acpi.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

-- 
Signature
