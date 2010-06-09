Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745Ab0FIHnh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 03:43:37 -0400
Received: from i1.inoi.fi ([194.100.97.46]:48500 "EHLO mail.inoi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370Ab0FIHng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 03:43:36 -0400
X-Greylist: delayed 1632 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Jun 2010 03:43:36 EDT
Date: Wed, 9 Jun 2010 10:16:23 +0300
From: Petri Lehtinen <petri.lehtinen@inoi.fi>
To: linux-kernel@vger.kernel.org
Subject: [stable] Please apply ucc_geth patches to 2.6.32-stable
Message-ID: <20100609071623.GC20057@colossus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following three patches fix some serious flaws in the ucc_geth
network driver in 2.6.32. From oldest to newest:

7583605b6d29f1f7f6fc505b883328089f3485ad ucc_geth: Fix empty TX queue processing
08b5e1c91ce95793c59a59529a362a1bcc81faae ucc_geth: Fix netdev watchdog triggering on link changes
34692421bc7d6145ef383b014860f4fde10b7505 ucc_geth: Fix full TX queue processing

They apply cleanly on top of 2.6.32-stable master. They were also
originally Cc'd to be included in 2.6.32-stable.

-- 
Petri Lehtinen
Software Specialist
Inoi Oy
Tel. : +358 40 758 0229
Email: petri.lehtinen@inoi.fi
