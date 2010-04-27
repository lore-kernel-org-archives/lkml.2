Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252Ab0D0RgV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 13:36:21 -0400
Received: from bar.sig21.net ([80.81.252.164]:38423 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755299Ab0D0RgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 13:36:20 -0400
Date: Tue, 27 Apr 2010 19:36:17 +0200
From: Johannes Stezenbach <js@sig21.net>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: fat: excessive log spamming due to corrupted fs
Message-ID: <20100427173617.GA712@sig21.net>
References: <20100422155944.GA22181@sig21.net>
 <87633d2pm3.fsf@devron.myhome.or.jp>
 <20100427101423.GA30678@sig21.net>
 <87wrvt16p7.fsf@devron.myhome.or.jp>
 <874oiw26hd.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874oiw26hd.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -3.7 (---)
X-Spam-21-Report: No, score=-3.7 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.725,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28, 2010 at 01:41:18AM +0900, OGAWA Hirofumi wrote:
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:
> 
> >> comment about KERN_CONT in kernel.h.  But maybe it only happens
> >> for /var/log/kern.log and my xconsole when generating too much
> >> output too quickly, "dmesg -s 10000000 | less" did not show
> >> the corruption (but only shows ~2700 lines out of the ~10000).
> 
> Um, please check syslog at same time with dmesg. If there is corruption
> in syslog, but there is not in dmesg. It sounds like userland problem.

I guess klogd cannot handle that much output.  If you'd add some
rate limiting that might fix the log corruption, too.

Thanks
Johannes
