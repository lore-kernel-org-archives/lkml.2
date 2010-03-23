Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab0CWDQ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 23:16:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43539 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753560Ab0CWDQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 23:16:55 -0400
Date: Tue, 23 Mar 2010 14:16:46 +1100
From: Neil Brown <neilb@suse.de>
To: jin zhencheng <zhenchengjin@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: BUG:write data to degrade raid5
Message-ID: <20100323141646.2cfa68a3@notabene.brown>
In-Reply-To: <de04351e1003190329l2f33447bhe37b963bd4b48c70@mail.gmail.com>
References: <de04351e1003190329l2f33447bhe37b963bd4b48c70@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Mar 2010 18:29:28 +0800
jin zhencheng <zhenchengjin@gmail.com> wrote:

> hi;
> 
> i use kernel is 2.6.26.2
> 
> what i do as follow:
> 
> 1, I create a raid5:
> mdadm -C /dev/md5 -l 5 -n 4 /dev/sda /dev/sdb /dev/sdc  /dev/sdd
> --metadata=1.0 --assume-clean
> 
> 2, dd if=/dev/zero of=/dev/md5 bs=1M &
> 
> write data to this raid5
> 
> 3, mdadm --manage /dev/md5 -f /dev/sda
> 
> 4 mdadm --manage  /dev/md5 -f /dev/sdb
> 
> if i faild 2 disks ,then the OS kernel display OOP error and kernel down
> 
> 
> do somebody know why ?
> 
> Is MD/RAID5 bug ?

Certainly this is a bug.
2.6.26 is quite old now - it is possible that the bug has already been fixed.
If you are able to post the oops message - possibly use a digital camera to
get a photograph - then I can probably explain what is happening and whether
it has been fixed.

Thanks,
NeilBrown

