Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907Ab2DBTsX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 15:48:23 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:20491 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab2DBTsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 15:48:22 -0400
Date: Mon, 2 Apr 2012 15:48:14 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs io errors on 3.4rc1
Message-ID: <20120402194814.GA10965@shiny.msi.event>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org
References: <20120402180214.GA1830@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120402180214.GA1830@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090203.4F7A0284.003D,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2012 at 02:02:14PM -0400, Dave Jones wrote:
> Updated to rc1 this morning, and my machines with btrfs are all freaking out..
> 
> I got this from my cron email ..
> 
> /etc/cron.daily/prelink: line 41: /var/lib/prelink/full: Input/output error
> cp: cannot create regular file `/var/lib/prelink/quick': Input/output error
> /etc/cron.daily/prelink: line 45: /var/log/prelink/prelink.log: Input/output error

That's not good.  Can you please try my for-linus branch against 3.3?
That will rules out all the shiny new btrfs code.

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

-chris
