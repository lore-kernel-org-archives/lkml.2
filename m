Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab0F1N67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 09:58:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16727 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432Ab0F1N66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 09:58:58 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Tao Ma <tao.ma@oracle.com>
Cc: axboe@kernel.dk, vgoyal@redhat.com, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, Joel Becker <joel.becker@oracle.com>,
       Sunil Mushran <sunil.mushran@oracle.com>,
       "ocfs2-devel\@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
Subject: Re: [PATCH 0/3 v5][RFC] ext3/4: enhance fsync performance when using CFQ
References: <1277242502-9047-1-git-send-email-jmoyer@redhat.com>
	<4C21D442.8080703@oracle.com> <4C22F316.3080009@oracle.com>
	<x49k4pk60ye.fsf@segfault.boston.devel.redhat.com>
	<4C284419.3000905@oracle.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 28 Jun 2010 09:58:51 -0400
In-Reply-To: <4C284419.3000905@oracle.com> (Tao Ma's message of "Mon, 28 Jun
	2010 14:41:29 +0800")
Message-ID: <x49hbknfeck.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tao Ma <tao.ma@oracle.com> writes:

> btw, I also met with a NULL pointer deference in cfq_yield. I have
> attached the null.log also. This seems to be related to the previous
> deadlock and happens when I try to remount the same volume after
> reboot and ocfs2 try to do some recovery.

Since I can't reproduce your binary kernel even with your .config, could
you send me the disassembly of the cfq_yield function from your vmlinux
binary?

Thanks!
Jeff
