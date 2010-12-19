Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708Ab0LSL6j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 06:58:39 -0500
Received: from lucidpixels.com ([75.144.35.66]:43202 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640Ab0LSL6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 06:58:38 -0500
X-Greylist: delayed 348 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Dec 2010 06:58:37 EST
Date: Sun, 19 Dec 2010 06:52:49 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
cc: linux-ext4@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
Subject: Is EXT4 the right FS for > 16TB?
Message-ID: <alpine.DEB.2.00.1012190649060.5393@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've read a lot of posts regarding people who setup RAID volumes of and up 
to around 16TB and EXT4 is typically used.

However, in various forums, people still ask what is the correct 
filesystem for > 16TB?  I did read one post somewhere that stated the ext4 
developers did not recommend using ext4 for very large volumes, is this 
still true?

I am looking at creating a 43TB volume possibly in the near future and I 
have used XFS in the past, which works well and would probably not have 
any problem with it; however, I have bitten quite a number of times by XFS 
bugs in the past several years, so I was curious, how does EXT4 perform on 
larger volumes, e.g., 20TB?

Are there any caveats / problems?

Justin.
