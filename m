Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658Ab2BPFlJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 00:41:09 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:20925 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab2BPFlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 00:41:07 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 0/4] PCI: quirk related clean up
Date: Wed, 15 Feb 2012 21:40:28 -0800
Message-Id: <1329370832-2253-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4F3C96EE.003D,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit:
| commit 3209874a1da2c51c7325e601d9634189ee178ad6
| Author: Arjan van de Ven <arjan@infradead.org>
| Date:   Mon Jan 30 20:52:07 2012 -0800
|
|    PCI: Annotate PCI quirks in initcall_debug style

will have lots of print out for quirks when initcall_debug is specified.

It turns out most of them are not really called for the devices because
quirks itself will check class id and bail out early.

Try to class into quirk declaration. So we could avoid dip into these quirks.

[PATCH 1/4] PCI: Add class support in quirk handling
[PATCH 2/4] PCI: Specify class for quirk entry with PCI_ANY_ID
[PATCH 3/4] PCI: Move out pci reassigndev resource alignment out of quirk
[PATCH 4/4] PCI: quirk print dev name with duration

Resending

Thanks

Yinghai
