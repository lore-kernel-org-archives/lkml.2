Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562Ab0D0TMF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 15:12:05 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:42641 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756188Ab0D0TMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 15:12:03 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Johannes Stezenbach <js@sig21.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: fat: excessive log spamming due to corrupted fs
References: <20100422155944.GA22181@sig21.net>
	<87633d2pm3.fsf@devron.myhome.or.jp>
	<20100427101423.GA30678@sig21.net>
	<87wrvt16p7.fsf@devron.myhome.or.jp>
	<874oiw26hd.fsf@devron.myhome.or.jp> <20100427173617.GA712@sig21.net>
Date: Wed, 28 Apr 2010 04:11:58 +0900
In-Reply-To: <20100427173617.GA712@sig21.net> (Johannes Stezenbach's message
	of "Tue, 27 Apr 2010 19:36:17 +0200")
Message-ID: <874oiwyakh.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Stezenbach <js@sig21.net> writes:

> On Wed, Apr 28, 2010 at 01:41:18AM +0900, OGAWA Hirofumi wrote:
>> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:
>> 
>> >> comment about KERN_CONT in kernel.h.  But maybe it only happens
>> >> for /var/log/kern.log and my xconsole when generating too much
>> >> output too quickly, "dmesg -s 10000000 | less" did not show
>> >> the corruption (but only shows ~2700 lines out of the ~10000).
>> 
>> Um, please check syslog at same time with dmesg. If there is corruption
>> in syslog, but there is not in dmesg. It sounds like userland problem.
>
> I guess klogd cannot handle that much output.  If you'd add some
> rate limiting that might fix the log corruption, too.

I guess it meant the corruption is in only syslog. Ok, it explains this
problem.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
