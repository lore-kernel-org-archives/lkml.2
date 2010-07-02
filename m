Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722Ab0GBLDx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 07:03:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35032 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753813Ab0GBLDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 07:03:51 -0400
Date: Fri, 2 Jul 2010 21:03:46 +1000
From: Nick Piggin <npiggin@suse.de>
To: David Howells <dhowells@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org,
       linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
       linux-ext4@vger.kernel.org
Subject: Re: [PATCH 1/3] xstat: Add a pair of system calls to make extended
 file stats available [ver #4]
Message-ID: <20100702110346.GB11732@laptop>
References: <20100701235727.19035.84584.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100701235727.19035.84584.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 02, 2010 at 12:57:28AM +0100, David Howells wrote:
> Add a pair of system calls to make extended file stats available, including
> file creation time, inode version and data version where available through the
> underlying filesystem.

Can you describe the expected atomicity requirements for the requests,
please?

Thanks,
Nick

