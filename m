Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932858Ab0J1MUy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 08:20:54 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57012 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118Ab0J1MUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 08:20:53 -0400
Date: Thu, 28 Oct 2010 14:20:45 +0200
From: Andi Kleen <andi@firstfloor.org>
To: lenb@kernel.org, linux-kernel@vger.kernel.org
Subject: intel idle kconfig warning
Message-ID: <20101028122045.GA6774@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Len,

Linus' latested gives this warning on 32bit allmodconfig:

include/config/auto.conf:4352:warning: symbol value 'm' invalid for INTEL_IDLE

Some problem with the intel idle Kconfig?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
