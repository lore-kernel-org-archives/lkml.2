Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666Ab1HaJWe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 05:22:34 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:56775 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987Ab1HaJWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 05:22:33 -0400
X-IronPort-AV: E=Sophos;i="4.68,306,1312156800"; 
   d="scan'208";a="7526622"
Subject: [PATCH 0/2] minor cleanups to EFLAGS initialisation in
 ret_from_fork
From: Ian Campbell <Ian.Campbell@citrix.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: Cyrill Gorcunov <gorcunov@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pekka Enberg <penberg@kernel.org>, Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Wed, 31 Aug 2011 10:22:21 +0100
Message-ID: <1314782541.28989.37.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fell off my radar but Cyrill kindly reminded me so here is a repost
of my short cleanup to remove the kernel_eflags variable from 64 bit and
to converge the ret_from_fork paths on 32 and 64 bit slightly.

This is unchanged from the last posting except I have rebased to current
tip/master and retested (it boots successfully on both 32 and 64 bit).

As previously discussed since the original posting I have switched to
converging on the 64 bit variant rather than the 32 bit variant.
Although I believe both variants are strictly speaking correct and
equivalent the 64 bit version seems to be more obviously so.

Ian.

