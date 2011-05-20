Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935535Ab1ETCDl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 22:03:41 -0400
Received: from mg2.springsoft.com ([220.128.66.238]:35693 "EHLO
	mg2.springsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935318Ab1ETCDi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 22:03:38 -0400
X-IronPort-AV: E=Sophos;i="4.65,240,1304265600"; 
   d="scan'208";a="1687268"
From: Karl Volk <karl_volk@springsoft.com>
To: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Date: Fri, 20 May 2011 10:03:36 +0800
Subject: lockf fails on 2.6 kernel over NFC
Thread-Topic: lockf fails on 2.6 kernel over NFC
Thread-Index: AcwWkiEdB3YYHDT0RyOkZpZ//Zk2Ew==
Message-ID: <BDFCF112A67CDA4981993297ACEB9B781FB19DAF3C@TWMAILA.springsoft.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, zh-TW
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have some basic code that calls lockf over nfs but it fails with ENOLCK. This only happens on one machine so it should be an environment issue specific to that machine. Kernel version Linux z400f35 2.6.9-78.ELsmp #1 SMP Wed Jul 9 15:56:26 EDT 2008 x86_64 x86_64 x86_64 GNU/Linux
.

There is a similar question titled "2.6: can't lockf() over NFS" but it seems unrelated to our problem. Rebooting the client and server machines has no effect. Our issue can be fixed by changing the IP address on the client. Is there a kernel patch for this?

The information contained in this e-mail message (including any attachments) may be confidential, proprietary, privileged, or otherwise exempt from disclosure under applicable laws. It is intended to be conveyed only to the designated recipient(s). Any use, dissemination, distribution, printing, retaining or copying of this e-mail (including its attachments) by unintended recipient(s) is strictly prohibited and may be unlawful. If you are not an intended recipient of this e-mail, or believe that you have received this e-mail in error, please notify the sender immediately (by replying to this e-mail), delete any and all copies of this e-mail (including any attachments) from your system, and do not disclose the content of this e-mail to any other person. Thank you!
