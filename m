Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab2ATOEs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 09:04:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32428 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570Ab2ATOEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 09:04:46 -0500
Date: Fri, 20 Jan 2012 15:04:44 +0100
From: Karel Zak <kzak@redhat.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        util-linux@vger.kernel.org
Subject: /etc/fstab.d yes or not
Message-ID: <20120120140444.GC13157@x2.net.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 I'd like to add support for /etc/fstab.d to libmount. The library is
 currently used by mount, umount and mount.nfs. The goal is to use it
 on more places.

 The /etc/fstab.d directory has been requested by people who maintains
 large number of mountpoints etc.

 The directory is not replacement for /etc/fstab, it's additional place
 where you can describe your filesystems.

 The disadvantage is that the stuff in the directory will be invisible
 for some tools (udisks, systemd, ...), so I have very vocal
 disagreement from some people who don't want to see /etc/fstab.d at all.

 BTW, systemd allows to define addition mountpoints in
 systemd.mount(5) unit file(s), so we already have additional place
 for fstab stuff...

 Commands? Objections?

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
