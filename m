Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918Ab2JDBot (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 21:44:49 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42570 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab2JDBor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 21:44:47 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <506CE9F5.8020809@jp.fujitsu.com>
Date: Thu, 4 Oct 2012 10:44:21 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: <linux-acpi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>
CC: <len.brown@intel.com>, <wency@cn.fujitsu.com>
Subject: [PATCH 0/2] acpi,memory-hotplug : remove memory device by acpi_bus_remove()
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch-set was divided from following thread's patch-set.

https://lkml.org/lkml/2012/9/5/201

If you want to know the reason, please read following thread.

https://lkml.org/lkml/2012/10/2/83

The patch exports "acpi_bus_remove()" for removing a acpi device from a
acpi bus at memory hot plug.


