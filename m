Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab1GNNxK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 09:53:10 -0400
Received: from adelie.canonical.com ([91.189.90.139]:56711 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755184Ab1GNNxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 09:53:08 -0400
Date: Thu, 14 Jul 2011 08:53:02 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Daniel Barkalow <barkalow@iabervon.org>
Cc: Christoph Hellwig <hch@tuxera.com>, linux-kernel@vger.kernel.org
Subject: Re: Problems with hfsplus on ipods in 2.6.38+
Message-ID: <20110714135302.GA28501@thinkpad-t410>
Mail-Followup-To: Daniel Barkalow <barkalow@iabervon.org>,
	Christoph Hellwig <hch@tuxera.com>, linux-kernel@vger.kernel.org
References: <alpine.LNX.2.00.1107131942190.2056@iabervon.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1107131942190.2056@iabervon.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 13, 2011 at 10:10:13PM -0400, Daniel Barkalow wrote:
> I've got an ipod which doesn't work with 2.6.38 or later, unless I revert:
> 
> 358f26d52680cb150907302d4334359de7dd2d59
> 52399b171dfaea02b6944cd6feba49b624147126
> 
> In the failing case, I get:
> 
>  sd 2:0:0:0: [sdb] Bad block number requested
>  hfs: unable to find HFS+ superblock
> 
> in dmesg when I try to mount it.
> 
> Before 2.6.38, or with those commits reverted, it mounts fine and works so 
> far as I can tell. (There's an Ubuntu bug report: 
> https://bugs.launchpad.net/ubuntu/+source/util-linux/+bug/734883, which 
> reports other people having similar results). I can test patches and 
> collect information that might be helpful, if you have any ideas.

This has had some discussion on lkml previously [1]. I've been trying to
work on a fix, but the current iteration has problems, and I haven't
been able to get testers to provide the logs I've requested to help me
see what's going wrong. If you'd like to help by providing logs from the
most recent test build on the bug you linked to (or using the patches
from that build) that would be great. I unfortunately don't have any
large-sector devices to test with and cannot reproduce the problems on
512-byte sector devices.

Seth

[1] https://lkml.org/lkml/2011/5/25/248
