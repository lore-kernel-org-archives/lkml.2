Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935551Ab2JaNMJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 09:12:09 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:38235 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932673Ab2JaNMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 09:12:07 -0400
Date: Wed, 31 Oct 2012 08:59:29 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org
Subject: Please add swiotlb.git tree to linux-next
Message-ID: <20121031125929.GA27144@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Please add:

 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/swiotlb.git #linux-next

in the linux-next system. The branch is 'linux-next'. This would be the
tree and branch used for maintaining the swiotlb and its different users.

The Ack's have already been given per this commit:

commit 6e28b761c5020c4bc943c7e38da86bea8af77d5c
Author: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date:   Mon Oct 8 16:28:05 2012 -0700

    MAINTAINERS: add Konrad as the SWIOTLB maintainer
    
    Now that I've an IA64 box on top of the other boxes (IBM with Calgary-X,
    Intel VT-d, AMD Vi, and AMD GART - that can use SWIOTLB as fallback) I can
    reliably do regression testing.
    
    Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
    Cc: Ingo Molnar <mingo@elte.hu>
    Acked-by: "H. Peter Anvin" <hpa@zytor.com>
    Cc: Thomas Gleixner <tglx@linutronix.de>
    Acked-by: Tony Luck <tony.luck@intel.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

