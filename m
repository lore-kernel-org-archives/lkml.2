Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab2DXLdj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 07:33:39 -0400
Received: from orion.tchmachines.com ([208.76.84.200]:54567 "EHLO
	orion.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab2DXLdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 07:33:38 -0400
From: Vlad Zolotarov <vlad@scalemp.com>
Organization: ScaleMP Ltd.
To: "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] Move x86_cpu_to_apicid to the __read_mostly section
Date: Tue, 24 Apr 2012 14:29:04 +0300
User-Agent: KMail/1.13.5 (Linux/2.6.32-40-generic; KDE/4.4.5; i686; ; )
Cc: alan@lxorguk.ukuu.org.uk,
        "Shai Fultheim (Shai@ScaleMP.com)" <Shai@scalemp.com>, ido@wizery.com,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201204241429.05526.vlad@scalemp.com>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - orion.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalemp.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan, pls., consider applying the following patch series.

The idea is to move x86_cpu_to_apicid to the __read_mostly section 
in order to avoid false sharing on large multiprocessing systems.

thanks,
vlad
