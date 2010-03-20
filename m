Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240Ab0CTPuz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 11:50:55 -0400
Received: from mail.tmr.com ([64.65.253.246]:51672 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753171Ab0CTPuy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 11:50:54 -0400
Message-ID: <4BA4EED7.5070700@tmr.com>
Date: Sat, 20 Mar 2010 11:50:47 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090507 Fedora/1.1.16-1.fc9 NOT Firefox/3.0.11 SeaMonkey/1.1.16
MIME-Version: 1.0
To: jin zhencheng <zhenchengjin@gmail.com>
CC: neilb@suse.de, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: BUG:write data to degrade raid5
References: <de04351e1003190329l2f33447bhe37b963bd4b48c70@mail.gmail.com>
In-Reply-To: <de04351e1003190329l2f33447bhe37b963bd4b48c70@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jin zhencheng wrote:
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
>   

I would usually say that any kernel OOPS is a bug, but in this case, 
what are you running your Linux on, given that you just trashed the 
first four drives? While it's possible to run off of other drives, you 
have to make an effort to configure Linux to do so.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

