Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758584Ab2KBVns (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 17:43:48 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:48413 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757887Ab2KBVnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 17:43:47 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: rjw@sisk.pl
Subject: [RFC] Suspend/resume without VT switches
Date: Fri,  2 Nov 2012 14:43:39 -0700
Message-Id: <1351892621-4840-1-git-send-email-jbarnes@virtuousgeek.org>
X-Mailer: git-send-email 1.7.9.5
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've lightly tested this with X and it definitely makes my
suspend/resume sequence a bit prettier.  It should speed things up
trivally as well, but most of those gains come from other changes to the
i915 driver (posted earlier to intel-gfx).

Any thoughts?  I suspect we'll have to be more defensive about the
resume configuration in case the BIOS did something weird, but overall I
think we should be able to do this one way or another.

Thanks,
Jesse

