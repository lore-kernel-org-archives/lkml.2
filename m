Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758487Ab0E1PEG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 11:04:06 -0400
Received: from mlbe2k2.cs.myharris.net ([137.237.90.89]:9832 "EHLO
	mlbe2k2.cs.myharris.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756800Ab0E1PEE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 11:04:04 -0400
X-Greylist: delayed 1212 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 May 2010 11:04:04 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RapidIO Kernel Module?
Date: Fri, 28 May 2010 10:43:49 -0400
Message-ID: <ED85DA5D3E53274E81DEBB85B226A2B7960BAC@mlbe2k9.cs.myharris.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: RapidIO Kernel Module?
Thread-Index: Acr+dCZVeTwe6/qfTCalgZc5rrRHkQ==
From: "Gordon, Burton" <bgordo03@harris.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 28 May 2010 14:43:50.0669 (UTC) FILETIME=[2FE52BD0:01CAFE74]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anybody done any work on converting or using the rapidio driver as a
LKM?
I have been trying out the rapidio driver for Linux. During this time I
see that device enumeration by the host only happens at boot time. In
the system I'm working on we will have to delay the bring-up of some
devices until after the host has booted. So my question, has anybody
done any work to make the rapidio (rio) kernel driver a loadable kernel
module? That looks like that would allow enumeration of devices after
the kernel is already up and running (possibly for a while).

Burt
