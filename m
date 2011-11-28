Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab1K1S77 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 13:59:59 -0500
Received: from blu0-omc1-s14.blu0.hotmail.com ([65.55.116.25]:30269 "EHLO
	blu0-omc1-s14.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753299Ab1K1S76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 13:59:58 -0500
X-Greylist: delayed 370 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Nov 2011 13:59:58 EST
X-Originating-IP: [87.194.136.79]
X-Originating-Email: [piercing_male@hotmail.com]
Message-ID: <BLU0-SMTP220EB3CE9494AA0EBBE58B098B20@phx.gbl>
Subject: linear raid, is partial recovery possible?
From: wilsonjonathan <piercing_male@hotmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Nov 2011 18:53:46 +0000
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Nov 2011 18:53:46.0807 (UTC) FILETIME=[0F12FC70:01CCADFF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quick question regarding linear raid.

If a disk fails on a linear raid I understand how the raid is
non-recoverable, as a whole, as it has lost a chunk of data.

However is it possible to recover the data from the non-failed portion
of the raid as I assume linear works by starting at one end of the array
and slowly progresses to the other?

Or perhaps it is dependent on the file system on the array, eg. ext
works by trying to place files distant to each other to help reduce the
possibility of fragmentation?

Perhaps the filesystem meta data, or some portion, may span between two
physical drives which would corrupt its table?

And obviously if a file spans two disks it would be missing part of its
data?

Does the raid underlying a file system do its own things, re-space,
physical data layout, etc; or does/can a file system impact on the
workings of an array?

The more I look into software raid the more fasinated I become with it
and its inner workings. While its way beyond me in some of the maths and
the fact I am un-proficient in C it has really caught my intrigue, and
all because I wanted to set up a small home server ;-)


