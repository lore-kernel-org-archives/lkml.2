Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab1IROni (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 10:43:38 -0400
Received: from netrider.rowland.org ([192.131.102.5]:39700 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750780Ab1IROnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 10:43:37 -0400
Date: Sun, 18 Sep 2011 10:43:36 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Rocko Requin <rockorequin@hotmail.com>
cc: tytso@mit.edu, <linux-kernel@vger.kernel.org>
Subject: RE: [Bug 25832] kernel crashes when a mounted ext3/4 file system is
 physically removed
In-Reply-To: <BAY151-W234D9A977DF076A732C2AAA1080@phx.gbl>
Message-ID: <Pine.LNX.4.44L0.1109181041070.703-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Sep 2011, Rocko Requin wrote:

> That patch worked, thanks - no more kernel crashes!

That's good news.

> I did see some slightly strange behaviour, though: the umounts issued
> by the script were not working correctly, so the drive was mounting
> successively on /dev/sdb1, /dev/sdc1, /dev/sdd1, etc again. After
> stopping the script, I was able to umount the various mountpoints
> manually, except for one (not the last one in the list, so not the
> most recently mounted one) which reported that the device was busy.
> lsof showed process jbd2/sdj1 three times, once with FD=cwd and
> TYPE=DIR, another with FD=rtd and TYPE=DIR, and lastly with FD=txt
> and TYPE=unknown.

Ted may have some ideas on how to find out what part of the unmount
commands is failing.

Alan Stern

