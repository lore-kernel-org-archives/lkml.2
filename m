Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932829Ab0HDNym (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 09:54:42 -0400
Received: from fallback1.mel.teaser.net ([213.162.54.52]:52919 "EHLO
	fallback1.mel.teaser.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932696Ab0HDNyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 09:54:39 -0400
X-Greylist: delayed 845 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Aug 2010 09:54:39 EDT
Date: Wed, 4 Aug 2010 15:40:32 +0200
From: Andre Majorel <aym-xunil@teaser.fr>
To: linux-kernel@vger.kernel.org
Subject: USB card reader trouble
Message-ID: <20100804134032.GF10980@aym.net2.nerim.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm having trouble reading Compact flash and SD cards on the
same card reader. I'm not absolutely certain but it *seems* that
once a medium of either type has been inserted, it will ignore
the other type.

Wherever the state is kept, it's not in the module. modprobe -r
usb-storage; modprobe usb-storage gives a kernel message about
"compact flash" even though the only medium in the reader is an
SD card.

Is there a secret /{proc|sys} spell to make it work ?

Thanks in advance.

-- 
André Majorel http://www.teaser.fr/~amajorel/
