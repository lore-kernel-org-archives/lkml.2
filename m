Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab0HCJXN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 05:23:13 -0400
Received: from lo.gmane.org ([80.91.229.12]:32993 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754079Ab0HCJXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 05:23:11 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Manuel Reimer <Manuel.Spam@nurfuerspam.de>
Subject: Re: Getting error message "Cannot read inode bitmap". Someone able
 to help?
Date: Tue, 03 Aug 2010 11:20:07 +0200
Message-ID: <i38n5j$pui$1@dough.gmane.org>
References: <i2nj7d$lpi$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: p4fd4a43d.dip0.t-ipconnect.de
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100721 SeaMonkey/2.0.6
In-Reply-To: <i2nj7d$lpi$1@dough.gmane.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Manuel Reimer wrote:
> With my first try (ext2 on target disk) I got the error "Cannot read
> inode bitmap". The kernel reported this error for the *target* device
> (the brand new SATA hard drive). I did a second try and reformated the
> target drive to ext3 and, again, I got the same error. So I installed
> "smartmontools" into my running live system and checked the drive. The
> new drive has no "reallocated sectors" but several read errors (about 500).

Sorry for the spam (maybe I'm on the wrong ML at all... don't know...) 
but I fixed this on my own. I didn't expect the new disk to be the 
reason for this problem, but after checking for badblocks I got a value 
far over 1000 of bad blocks.

So I'll send this disk back to the vendor to get my money back and get a 
new one...

Nice to know, that Linux was *not* the reason for those errors.

Yours

Manuel

