Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937054Ab0COWuq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 18:50:46 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39670 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936991Ab0COWun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 18:50:43 -0400
Date: Mon, 15 Mar 2010 22:50:37 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jeff Layton <jlayton@redhat.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: Re: [PATCH] vfs: pass struct file to do_truncate on O_TRUNC opens
Message-ID: <20100315225037.GX30031@ZenIV.linux.org.uk>
References: <1268689152-19168-1-git-send-email-jlayton@redhat.com>
 <1268692288.3040.2.camel@localhost.localdomain>
 <20100315184702.35c4d140@tlielax.poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100315184702.35c4d140@tlielax.poochiereds.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 15, 2010 at 06:47:02PM -0400, Jeff Layton wrote:

> Yeah that would be cleaner on the wire for the create case. It's not
> clear to me how to implement that though. There doesn't appear to be
> a straightforward way to tell the VFS to skip the truncate.

The plan is to turn most of the guts of do_last() into fs method...
