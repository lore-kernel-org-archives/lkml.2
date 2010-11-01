Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730Ab0KAXKY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 19:10:24 -0400
Received: from wdscspam2.wdc.com ([129.253.170.131]:42860 "EHLO
	wdscspam2.wdc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879Ab0KAXKW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 19:10:22 -0400
X-Greylist: delayed 571 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Nov 2010 19:10:22 EDT
X-IronPort-AV: E=Sophos;i="4.58,277,1286175600"; 
   d="scan'208,223";a="164404460"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: hibernate and file system/metadisk driver buffers/caches
Date: Mon, 1 Nov 2010 15:59:36 -0700
Message-ID: <25B374CC0D9DFB4698BB331F82CD0CF20D601F@wdscexbe08.sc.wdc.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: hibernate and file system/metadisk driver buffers/caches
Thread-Index: Act6GHP4xaq1VwKWQ+WDDNcnazLFfQ==
From: "Daniel Taylor" <Daniel.Taylor@wdc.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 01 Nov 2010 23:00:35.0730 (UTC) FILETIME=[97F34F20:01CB7A18]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-6.500.1024-17740.002
X-TM-AS-Result: No--9.796500-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From what I have found in Documentation/power, I should be
able to hibernate a system to a partition on flash, and
resume it, preserving its entire state.

In case I missed something, though, does anyone know if,
in particular, MD stripe buffers are preserved, as well
as the EXTn/XFS buffers/caches?  I think I read that I/O
buffers in use by drivers are saved only if the driver
has the appropriate suspend() interfaces.

Dan Taylor
