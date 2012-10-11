Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab2JKFTv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 01:19:51 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60776 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620Ab2JKFTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 01:19:50 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <507656D1.5020703@jp.fujitsu.com>
Date: Thu, 11 Oct 2012 14:19:13 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
CC: <rientjes@google.com>, <liuj97@gmail.com>, <minchan.kim@gmail.com>,
        <akpm@linux-foundation.org>, <kosaki.motohiro@jp.fujitsu.com>,
        <isimatu.yasuaki@jp.fujitsu.com>, <wency@cn.fujitsu.com>
Subject: [PATCH v2 0/2] Suppress "Device <device name> does not have a release()
 function" warning
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set is patches to which [1] and [2] are updated
  [1] memory-hotplug: add memory_block_release
  [2] memory-hotplug: add node_device_release
from following patch-set.

https://lkml.org/lkml/2012/9/27/39

So the patch-set version is v2.

v1 -> v2
[PATCH 1/2]
- change subject to Suppress "Device memoryX does not have a release()
  function" warning.
- Add detail information into description
- change function name from release_memory_block() to memory_block_release(),
  because other device release() function is named to <device_name>_release()
[PATCH 2/2]
- change subject to Suppress "Device nodeX does not have a release() function"
  warning.
- Add detail information into description
- Remove memset() to initialize a node struct from node_device_release()
- Add memset() to initialize a node struct into register_node()


