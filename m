Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab1AREzN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 23:55:13 -0500
Received: from wipro-blr-out01.wipro.com ([203.91.198.74]:60928 "EHLO
	wipro-blr-out02.wipro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752736Ab1AREzM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 23:55:12 -0500
X-AuditID: cb5bdd58-b7cbcae000005855-70-4d351d2e19c4
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Regarding platform drivers
Date: Tue, 18 Jan 2011 10:25:08 +0530
Message-ID: <B1C038EEDA7E0344BC837F2D591C949803B7EC0A@blr-m3-msg.wipro.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Regarding platform drivers
Thread-Index: Acu2yUGdEWaqkoXPQnS1E53P5wyzbgAAmUCg
From: <ananth.sundapalayam@wipro.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 18 Jan 2011 04:55:09.0201 (UTC) FILETIME=[E1BC2010:01CBB6CB]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I noticed that certain drivers are registered as platform drivers. 
As a driver writer, what factors do I need to consider to decide if my
driver would be a platform driver or a "regular" driver?
If I have a DMA controller connected to the CPU via a Network-On-Chip,
could I write a regular driver for it or does it need to be a platform
driver?

Thanks in advance,

Best Regards,
Ananth.

PS: Kindly include my mail id in your response.

