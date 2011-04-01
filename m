Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985Ab1DAORZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 10:17:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:53679 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756797Ab1DAORY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 10:17:24 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=XYJHFtupD_QA:10 a=EVKuf7F6qnwA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=cGEwbORt6sXYahs3DtYA:9 a=CjuIK1q_8ugA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Fri, 1 Apr 2011 10:17:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jurriaan <thunder8@xs4all.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.38 crash (null pointer reference at
 mark_inode_dirty+0xa1/0x151)
Message-ID: <20110401141723.GH14441@home.goodmis.org>
References: <20110331143227.GA8238@onderneming10.xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110331143227.GA8238@onderneming10.xs4all.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 02:32:27PM +0000, Jurriaan wrote:
> My laptop, running Debian Unstable + 2.6.38 debian kernel from
> experimantal, just crashed.
> 
> unable to handle null reference pointer
> mark_inode_dirty+0xa1/0x151
> 
> call trace (top lines)
> setattr_copy
> fat_setattr
> path_init_rcu
> need_resched
> 
> After resuming, I was adding backgrounds to Desktop Drapes and running
> rsync from an ext4 partition to an USB stick with a vfat filesystem.

Hi, 

Thanks for the report. As this looks like you hand typed the output, I
doubt you have any way to save the full dump. Could you be able to take
a digital photo of the screen and upload it somewhere?

Thanks,

-- Steve

