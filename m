Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab1CUOAO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 10:00:14 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:34713 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752968Ab1CUOAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 10:00:12 -0400
Date: Mon, 21 Mar 2011 16:00:02 +0200
From: Felipe Balbi <balbi@ti.com>
To: Hannes Reinecke <hare@suse.de>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: AICASM build breakage
Message-ID: <20110321135946.GL1837@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just got a build break on aicasm.c file after a make randconfig. The
build breakage seems relevant as aicdb.h doesn't exist.

aicasm_symbol.c:48:19: fatal error: aicdb.h: No such file or directory
compilation terminated.
make[4]: *** [aicasm] Error 1
make[3]: *** [drivers/scsi/aic7xxx/aicasm/aicasm] Error 2
make[2]: *** [drivers/scsi/aic7xxx] Error 2
make[1]: *** [drivers/scsi] Error 2
make: *** [drivers] Error 2

-- 
balbi
