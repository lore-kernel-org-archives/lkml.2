Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab2L3LdW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2012 06:33:22 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:34490 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912Ab2L3LdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2012 06:33:18 -0500
MIME-Version: 1.0
From: Vivek Satpute <vivekonline86@gmail.com>
Date: Sun, 30 Dec 2012 17:02:56 +0530
Message-ID: <CAK4r=d6--9FniNQ10Ja0z4hUQHuTnCPjsHJUHDmFP7Eeo8NwAA@mail.gmail.com>
Subject: Request-queue not getting process even after calling unplug
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I am working on RHEL5.8 (kernel-2.6.18-308) and facing weird behavior
with the IO subsystem.

My testcase requires to form the SCSI request manually and send it
down to the underlying HBA
for further IO processing. To achieve this I have formed the SCSI
request, packed it inside the
new request. Later on I am queuing the request to device's
request-queue using function - elv_add_request( ).
Request is getting queued correctly in a queue. Further I called
unplug on a queue, still it is not getting
processed further by IO scheduler. Request remains stuck in queue itself !

Strange part is, same code is working successfully on other kernel versions,
but I am facing the issue only on kernel-2.6.18-308.

Can anyone help me to understand why request is being stuck in a queue
? How can I debug this further ?


Thanks in advance!
Vivek Satpute
