Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427Ab0CSNOU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 09:14:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46852 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752262Ab0CSNOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 09:14:17 -0400
Date: Fri, 19 Mar 2010 14:12:09 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Can not boot with CONFIG_NO_BOOTMEM=y on i686
Message-ID: <20100319131208.GA3911@dhcp-lab-161.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

After update to 2.6.34-rc1, I was experimented by strange oopses during
boot, what looked like memory corruption. Bisection shows that first bad
commit is 59be5a8e8ce765cf739ec7f07176219972de7481 ("x86: Make 32bit
support NO_BOOTMEM"). When I disable CONFIG_NO_BOOTMEM I'm able to start
system. Not sure what info is need to track down this issue, so please
let me know.

Cheers
Stanislaw
