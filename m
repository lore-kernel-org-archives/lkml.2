Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704Ab2KIOPN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 09:15:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35023 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405Ab2KIOPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 09:15:10 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, kernel-team@lists.ubuntu.com
Subject: [ANNOUNCE] Extended stable support for Linux 3.5 (linux-3.5.y-ext.z)
Date: Fri,  9 Nov 2012 12:15:04 -0200
Message-Id: <1352470505-6097-1-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As everyone may be aware, linux 3.5.y isn't anymore a supported stable
kernel tree. Also, it seems not many distributions picked 3.5 as a
kernel version for their releases, looks like due to timing. Anyway, as
Ubuntu is using it in its 12.10 release (codename "Quantal Quetzal"),
we (as in Ubuntu kernel maintainers) are going forward and announcing
that we will provide extended stable support for it. I'm the person
going to maintain this effort at first. This is a 3rd party effort from
us, it will be for now a fork of latest 3.5.7 stable release, maintained
on our infra-structure.

The tree providing the extended stable updates is located at
git://kernel.ubuntu.com/ubuntu/linux.git, which is where we will
maintain the patches and releases of this extended support. The page at
http://wiki.ubuntu.com/Kernel/Dev/ExtendedStable describes the stucture
and other details. Worth to note is that we plan to provide this
extended support only until March 31st, 2014

I plan to do a similar workflow as to what is done today with current
stable releases. I'll send email notifications to everyone involved in
each patch when it's added to 3.5 queue, and post the patches for review
for each release cycle. Just versioning will be slightly different,
every version is planned to be tagged as v3.5.7-ext.<release number>,
ext meaning extended, 3.5.7 was the last stable kernel in 3.5 kernel and
should remain constant.

We welcome any feedback and contribution to this effort, and help in
reviewing or any request of patches to be added, keeping in mind that it
must follow the official upstream stable kernel rules as usual. Next
week I plan to post the first set of patches for review for a first
release.

thanks,
- Herton
