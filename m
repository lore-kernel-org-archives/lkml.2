Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730Ab2GKHll (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 03:41:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49721 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018Ab2GKHlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 03:41:39 -0400
Date: Wed, 11 Jul 2012 00:44:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: dedekind1@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: mmotm 2012-07-10-16-59 uploaded
Message-Id: <20120711004430.0d14f0b6.akpm@linux-foundation.org>
In-Reply-To: <1341988680.2963.128.camel@sauron>
References: <20120711000148.BAD1E5C0050@hpza9.eem.corp.google.com>
	<1341988680.2963.128.camel@sauron>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2012 09:38:00 +0300 Artem Bityutskiy <dedekind1@gmail.com> wrote:

> Andrew, thanks for picking my changes!
> 
> On Tue, 2012-07-10 at 17:01 -0700, akpm@linux-foundation.org wrote:
> > * hfs-get-rid-of-hfs_sync_super-checkpatch-fixes.patch
> 
> > * hfsplus-get-rid-of-write_super-checkpatch-fixes.patch
> 
> I sent updated versions which would fix checkpatch.pl complaints. I
> guess you did not notice them or was unable to pick because I think I
> PGP-signed them?

I looked at them, but they're identical to what I now have, so nothing
needed doing.
