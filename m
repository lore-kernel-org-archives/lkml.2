Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461Ab1DOWCm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 18:02:42 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:64568 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756080Ab1DOWCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 18:02:18 -0400
X-IronPort-AV: E=Sophos;i="4.64,221,1301875200"; 
   d="scan'208";a="5332531"
Subject: Re: [PATCH] xen: cleancache shim to Xen Transcendent Memory
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: <chris.mason@oracle.com>, <viro@zeniv.linux.org.uk>,
        <akpm@linux-foundation.org>, <adilger.kernel@dilger.ca>,
        <tytso@mit.edu>, <mfasheh@suse.com>, <jlbec@evilplan.org>,
        <matthew@wil.cx>, <linux-btrfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-ext4@vger.kernel.org>, <ocfs2-devel@oss.oracle.com>,
        <linux-mm@kvack.org>, <hch@infradead.org>, <ngupta@vflare.org>,
        <jeremy@goop.org>, <JBeulich@novell.com>, <kurt.hackel@oracle.com>,
        <npiggin@kernel.dk>, <dave.mccracken@oracle.com>, <riel@redhat.com>,
        <avi@redhat.com>, <konrad.wilk@oracle.com>, <mel@csn.ul.ie>,
        <yinghan@google.com>, <gthelen@google.com>,
        <torvalds@linux-foundation.org>
In-Reply-To: <20110414212002.GA27846@ca-server1.us.oracle.com>
References: <20110414212002.GA27846@ca-server1.us.oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Organization: Citrix Systems, Inc.
Date: Fri, 15 Apr 2011 23:02:15 +0100
Message-ID: <1302904935.22658.9.camel@localhost.localdomain>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-14 at 14:20 -0700, Dan Magenheimer wrote:
> [PATCH] xen: cleancache shim to Xen Transcendent Memory
> 
> This patch provides a shim between the kernel-internal cleancache
> API (see Documentation/mm/cleancache.txt) and the Xen Transcendent
> Memory ABI (see http://oss.oracle.com/projects/tmem).

There's no need to build this into a kernel which doesn't have
cleancache (or one of the other frontends), is there? I think there
should be a Kconfig option (even if its not a user visible one) with the
appropriate depends/selects.

Ian.

