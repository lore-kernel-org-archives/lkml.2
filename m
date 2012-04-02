Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab2DBVQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 17:16:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636Ab2DBVQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 17:16:27 -0400
Date: Mon, 2 Apr 2012 17:16:22 -0400
From: Dave Jones <davej@redhat.com>
To: Chris Mason <chris.mason@oracle.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs io errors on 3.4rc1
Message-ID: <20120402211622.GA2487@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Chris Mason <chris.mason@oracle.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org
References: <20120402180214.GA1830@redhat.com>
 <20120402194814.GA10965@shiny.msi.event>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120402194814.GA10965@shiny.msi.event>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2012 at 03:48:14PM -0400, Chris Mason wrote:
 > On Mon, Apr 02, 2012 at 02:02:14PM -0400, Dave Jones wrote:
 > > Updated to rc1 this morning, and my machines with btrfs are all freaking out..
 > > 
 > > I got this from my cron email ..
 > > 
 > > /etc/cron.daily/prelink: line 41: /var/lib/prelink/full: Input/output error
 > > cp: cannot create regular file `/var/lib/prelink/quick': Input/output error
 > > /etc/cron.daily/prelink: line 45: /var/log/prelink/prelink.log: Input/output error
 > 
 > That's not good.  Can you please try my for-linus branch against 3.3?
 > That will rules out all the shiny new btrfs code.
 > 
 > git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus
 > 
 > -chris

Broken.

(17:14:52:davej@dhcp-189-232:~)$ fsx foo
truncating to largest ever: 0x13e76
truncating to largest ever: 0x2e52c
ftruncate1: 2e52c
dotruncate: ftruncate: Input/output error
Segmentation fault (core dumped)

	Dave
