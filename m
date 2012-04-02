Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab2DBV1y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 17:27:54 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:27673 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab2DBV1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 17:27:51 -0400
Date: Mon, 2 Apr 2012 17:26:08 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs io errors on 3.4rc1
Message-ID: <20120402212608.GA14958@shiny.msi.event>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org
References: <20120402180214.GA1830@redhat.com>
 <20120402194814.GA10965@shiny.msi.event>
 <20120402211622.GA2487@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120402211622.GA2487@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090203.4F7A19D5.00B2,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2012 at 05:16:22PM -0400, Dave Jones wrote:
> On Mon, Apr 02, 2012 at 03:48:14PM -0400, Chris Mason wrote:
>  > On Mon, Apr 02, 2012 at 02:02:14PM -0400, Dave Jones wrote:
>  > > Updated to rc1 this morning, and my machines with btrfs are all freaking out..
>  > > 
>  > > I got this from my cron email ..
>  > > 
>  > > /etc/cron.daily/prelink: line 41: /var/lib/prelink/full: Input/output error
>  > > cp: cannot create regular file `/var/lib/prelink/quick': Input/output error
>  > > /etc/cron.daily/prelink: line 45: /var/log/prelink/prelink.log: Input/output error
>  > 
>  > That's not good.  Can you please try my for-linus branch against 3.3?
>  > That will rules out all the shiny new btrfs code.
>  > 
>  > git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus
>  > 
>  > -chris
> 
> Broken.
> 
> (17:14:52:davej@dhcp-189-232:~)$ fsx foo
> truncating to largest ever: 0x13e76
> truncating to largest ever: 0x2e52c
> ftruncate1: 2e52c
> dotruncate: ftruncate: Input/output error
> Segmentation fault (core dumped)

Huh.  x86-32 or x86-64?  I know you said there were no interesting
messages, but could you please send the messages you did get?

-chris

