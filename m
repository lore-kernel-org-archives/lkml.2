Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921Ab0EGQMF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 12:12:05 -0400
Received: from neskaya.eckenfels.net ([195.49.138.57]:63001 "EHLO
	neskaya.eckenfels.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835Ab0EGQMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 12:12:03 -0400
X-Greylist: delayed 2463 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 May 2010 12:12:03 EDT
Date: Fri, 7 May 2010 17:28:31 +0200 (CEST)
Message-Id: <201005071528.o47FSVas054141@neskaya.eckenfels.net>
From: Bernd Eckenfels <bernd-10@eckenfels.net>
To: linux-kernel@vger.kernel.org
Subject: Re: ext4 is faster with LVM than without, and other filesystem benchmarks
In-Reply-To: <20100507142310.GF13143@lh.kyla.fi>
X-Newsgroups: ka.lists.linux.kernel
User-Agent: tin/1.8.3-20070201 ("Scotasay") (UNIX) (FreeBSD/7.2-PRERELEASE (i386))
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: ecki@neskaya.eckenfels.net
X-SA-Exim-Scanned: No (on neskaya.eckenfels.net); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In article <20100507142310.GF13143@lh.kyla.fi> you wrote:
> I think the most surprising result of the benchmarks is that ext4
> seems to be significantly faster under LVM than on the raw /dev/sdd1
> partition. Without LVM the variance in run times is much larger.

Sounds like the syncs/barriers never reach the disk with LVM. What mount
journal/sync options did you use?  default?  Is dmesg telling you that
barriers have been turned off for the lvm case?  IF yo uwant it fast and
dirty try nobarrier,data=writeback :)

Greetings
Bernd
