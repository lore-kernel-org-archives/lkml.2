Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339Ab1AZXWT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 18:22:19 -0500
Received: from trent.utfs.org ([194.246.123.103]:59593 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753988Ab1AZXWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 18:22:18 -0500
Date: Wed, 26 Jan 2011 15:22:14 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
To: "Dr. Bernd Feige" <bernd.feige@uniklinik-freiburg.de>
cc: Al Viro <viro@ZenIV.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        david@fromorbit.com, npiggin@gmail.com
Subject: Re: Linux 2.6.37 x86 ncpfs regression: kernel BUG at include/linux/dcache.h:340
 with >1366 files in directory
In-Reply-To: <1296062778.2674.2.camel@pst15.ukl.uni-freiburg.de>
Message-ID: <alpine.DEB.2.01.1101261457480.7903@trent.utfs.org>
References: <1296053700.2684.19.camel@pst15.ukl.uni-freiburg.de>  <20110126163203.GP22723@ZenIV.linux.org.uk>  <1296061412.2684.59.camel@pst15.ukl.uni-freiburg.de> <1296062778.2674.2.camel@pst15.ukl.uni-freiburg.de>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Jan 2011 at 18:26, Dr. Bernd Feige wrote:
> my apologies. You hit the nail on the head! Of course plain 2.6.37
> contains 3825bdb7ed920845961f32f364454bee5f469abb - downloaded it again,
> reverted it, and no "kernel BUG" any more!

Hasn't there been an earlier 
attempt[0] to remove 3825bdb7ed920845961f32f364454bee5f469abb back in Nov 
2010?

Christian.

[0] http://www.gossamer-threads.com/lists/linux/kernel/1308598
-- 
BOFH excuse #243:

The computer fleetly, mouse and all.
