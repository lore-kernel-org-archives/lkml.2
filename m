Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757683Ab1EYN3h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 09:29:37 -0400
Received: from frankvm.xs4all.nl ([83.163.148.79]:47560 "EHLO
	janus.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756719Ab1EYN3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 09:29:36 -0400
X-Greylist: delayed 338 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 May 2011 09:29:36 EDT
Date: Wed, 25 May 2011 15:23:56 +0200
From: Frank van Maarseveen <frankvm@frankvm.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.37, 2.6.38, 2.6.39 vfs/ext3/ext4 crash when unplugging USB storage
Message-ID: <20110525132356.GA6296@janus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel crashes in various interesting ways using this command sequence
with an ext3/ext4 formatted USB storage device (not write-preotected):

	mount /dev/sdb1 /mnt
	cd /mnt
	ls
	# unplug device here
	umount -l -f /mnt
	cd

Reproducable on FC15 live image using the file manager.

-- 
Frank
