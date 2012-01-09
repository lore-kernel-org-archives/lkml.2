Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab2AIA4u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 19:56:50 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:48924 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755009Ab2AIA4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 19:56:50 -0500
Date: Mon, 9 Jan 2012 00:56:46 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Eric Paris <eparis@redhat.com>
Cc: torvalds@linux-foundation.org, jj@chaosbits.net,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] audit: always follow va_copy() with va_end()
Message-ID: <20120109005646.GT23916@ZenIV.linux.org.uk>
References: <139540383.1157551.1326070431707.JavaMail.root@zmail13.collab.prod.int.phx2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <139540383.1157551.1326070431707.JavaMail.root@zmail13.collab.prod.int.phx2.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 08, 2012 at 07:53:51PM -0500, Eric Paris wrote:
> This one was committed to my audit tree which al promised to pull all of my audit tree into the vfs tree for 3.3, so if you want to take it Linus, you can add my ack as the maintainer. I'd expect to see it from Al early this week. Can't say anything about SCSI though...

s/vfs/recreated audit/; should've done that a month or so ago.  Will do
tonight...
