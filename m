Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203Ab2DQLTY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 07:19:24 -0400
Received: from orion.tchmachines.com ([208.76.84.200]:41593 "EHLO
	orion.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755496Ab2DQLTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 07:19:22 -0400
X-Greylist: delayed 4159 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Apr 2012 07:19:21 EDT
From: Vlad Zolotarov <vlad@scalemp.com>
Organization: ScaleMP Ltd.
Subject: [PATCH 0/2] Move x86_cpu_to_apicid to the __read_mostly section
Date: Tue, 17 Apr 2012 14:15:55 +0300
User-Agent: KMail/1.13.5 (Linux/2.6.32-40-generic; KDE/4.4.5; i686; ; )
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Cc: "Shai Fultheim (Shai@ScaleMP.com)" <Shai@scalemp.com>, ido@wizery.com
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201204171415.55969.vlad@scalemp.com>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - orion.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalemp.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move x86_cpu_to_apicid to the __read_mostly sectionin order to avoid false
sharing on large multiprocessing systems.

thanks,
vlad
