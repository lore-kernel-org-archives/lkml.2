Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679Ab0DUXNI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 19:13:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38004 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752431Ab0DUXND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 19:13:03 -0400
Date: Wed, 21 Apr 2010 16:12:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jing Huang <huangj@Brocade.com>
Cc: <sfr@canb.auug.org.au>, <James.Bottomley@suse.de>,
       <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <linux-scsi@vger.kernel.org>, <kgudipat@Brocade.com>,
       <rvadivel@Brocade.com>, <vravindr@Brocade.com>
Subject: Re: [PATCH] bfa: fix compilation warning in powerpc (resend)
Message-Id: <20100421161217.60d5654b.akpm@linux-foundation.org>
In-Reply-To: <1271186549-642-1-git-send-email-huangj@brocade.com>
References: <1271186549-642-1-git-send-email-huangj@brocade.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Apr 2010 12:22:29 -0700
Jing Huang <huangj@Brocade.com> wrote:

> Fix the compilation warning in powerpc.

When fixing a warning, please quote that warning in the patch description!

<does a cross-build>

It seems that you're referring to this:

drivers/scsi/bfa/bfa_ioc.c: In function 'bfa_ioc_msgget':
drivers/scsi/bfa/bfa_ioc.c:1331: warning: value computed is not used
drivers/scsi/bfa/bfa_ioc_ct.c: In function 'bfa_ioc_ct_notify_hbfail':
drivers/scsi/bfa/bfa_ioc_ct.c:177: warning: value computed is not used
drivers/scsi/bfa/bfa_ioc_ct.c:180: warning: value computed is not used
drivers/scsi/bfa/bfa_ioc_ct.c: In function 'bfa_ioc_ct_pll_init':
drivers/scsi/bfa/bfa_ioc_ct.c:381: warning: value computed is not used
drivers/scsi/bfa/bfa_ioc_ct.c: In function 'bfa_ioc_ct_ownership_reset':
drivers/scsi/bfa/bfa_ioc_ct.c:421: warning: value computed is not used
drivers/scsi/bfa/bfa_ioc_cb.c: In function 'bfa_ioc_cb_notify_hbfail':
drivers/scsi/bfa/bfa_ioc_cb.c:99: warning: value computed is not used
drivers/scsi/bfa/bfa_ioc_cb.c: In function 'bfa_ioc_cb_ownership_reset':
drivers/scsi/bfa/bfa_ioc_cb.c:272: warning: value computed is not used


> The same change also fixes endian
> issue we found in powerpc test.

When fixing a bug, please fully describe the bug!

If this driver has "endian issues" on powerpc then it's quite possible
that this is a running-around-with-hair-on-fire,
must-backport-to-2.6.33.x bugfix.

But how would I know?  You didn't tell me!


