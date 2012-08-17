Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278Ab2HQPaS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 11:30:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33772 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756989Ab2HQPaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 11:30:11 -0400
From: Alex Elsayed <eternaleye@gmail.com>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [ANNOUNCE] target-pending tree updated to v3.6-rc2
Date: Fri, 17 Aug 2012 08:30:03 -0700
Message-ID: <1612895.ZlIZRoGI8L@arkadios>
User-Agent: KMail/4.8.3 (Linux/3.5.0-00163-g4e675ba; KDE/4.8.3; x86_64; ; )
In-Reply-To: <1345186184.25161.141.camel@haakon2.linux-iscsi.org>
References: <1345171412.25161.134.camel@haakon2.linux-iscsi.org> <1345186184.25161.141.camel@haakon2.linux-iscsi.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 16, 2012 11:49:44 PM Nicholas A. Bellinger wrote:
> On Thu, 2012-08-16 at 19:43 -0700, Nicholas A. Bellinger wrote:
> > Hi all,
> > 
> > With the release of v3.6-rc2 this afternoon, the target-pending.git tree
> > now has been updated using the freshly cut -rc2 as it's new HEAD.
> > Patches destined into for-3.7 code are now being added into for-next for
> > linux-next build testing.
> > 
> > Also, thanks go out to MST, Stefan, and Paolo who managed to get
> > tcm_vhost fabric code merged in mainline for -rc2  under the special
> > post merge window exception rule for new kernel code, which in my
> > experience tends to happens about as often as Haley's comet comes
> > around..
> > 
> > Here is the current breakdown of pending patches by branch:
> > 
> > master: (patches headed for 3.6-rc-fixes)
> > 
> > 5b7517f8 tcm_vhost: Change vhost_scsi_target->vhost_wwpn to char *
> > d0e27c88 target: fix NULL pointer dereference bug alloc_page() fails to
> > get memory 1fa8f450 tcm_fc: Avoid debug overhead when not debugging
> > 101998f6 tcm_vhost: Post-merge review changes requested by MST
> > f0e0e9bb tcm_vhost: Fix incorrect IS_ERR() usage in
> > vhost_scsi_map_iov_to_sgl
> Whoops..  Missed one extra target/pscsi regression bug-fix reported
> recently by Alex Elsayed (CC'ed) that has just been pushed into master
> here:
> 
> target/pscsi: Fix bug with REPORT_LUNs handling for SCSI passthrough
> http://git.kernel.org/?p=linux/kernel/git/nab/target-pending.git;a=commitdif
> f;h=1d2a2cd95ee0137a2353d1b5635739c281f27cd4
> 
> Alex-E, you where able to get TYPE_ROM passthrough w/ pSCSI export
> working on your setup with this patch, yes..?
> 
> Thanks!
> 
> --nab

The patch got it to where XP and Windows 7 would recognize it and mount it, 
but there's still some weirdness - for instance, opening it in the file browser 
hangs for an extended period of time before it starts working. No noise in 
dmesg when that happens, and I haven't had time to look deeper.
