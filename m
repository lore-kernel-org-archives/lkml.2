Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab0FMO6R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 10:58:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58833 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754120Ab0FMO5h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 10:57:37 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>, "Jan Kara" <jack@suse.cz>,
       "Marius Tolzmann" <tolzmann@molgen.mpg.de>,
       "Miklos Szeredi" <mszeredi@suse.cz>,
       "OGAWA Hirofumi" <hirofumi@mail.parknet.co.jp>
References: <g77CuMUl7QI.A.5wF.V5OFMB@chimera>
In-Reply-To: <g77CuMUl7QI.A.5wF.V5OFMB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <YPGdyfWGvNK.A.KL.C7OFMB@chimera>
Subject: [Bug #15909] open("a/",O_NOFOLLOW) fails with ELOOP if "a" is a symbolic link to a directory.
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 13 Jun 2010 16:48:58 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.33 and 2.6.34.

The following bug entry is on the current list of known regressions
introduced between 2.6.33 and 2.6.34.  Please verify if it still should
be listed and let the tracking team know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15909
Subject		: open("a/",O_NOFOLLOW) fails with ELOOP if "a" is a symbolic link to a directory.
Submitter	: Marius Tolzmann <tolzmann@molgen.mpg.de>
Date		: 2010-05-05 13:01 (40 days old)
Handled-By	: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
		  Jan Kara <jack@suse.cz>
Patch		: https://patchwork.kernel.org/patch/99291/


