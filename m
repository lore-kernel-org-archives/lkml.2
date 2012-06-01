Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757652Ab2FANBX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 09:01:23 -0400
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:35601 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753011Ab2FANBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 09:01:22 -0400
Date: Fri, 1 Jun 2012 16:01:21 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Jean Delvare <khali@linux-fr.org>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: f71805f arch dependencies?
Message-ID: <alpine.SOC.1.00.1206011559370.10517@math.ut.ee>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Loading f71805f on sparc64 causes hard reboot beacuse on invalid 
hardware access. Should this driver be restricted to PC, or some wider 
subset of platforms where this LPC SUper-IO chip is present?

-- 
Meelis Roos (mroos@linux.ee)
