Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760447Ab2C3CkB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 22:40:01 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43956 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759139Ab2C3Cjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 22:39:54 -0400
Date: Fri, 30 Mar 2012 03:39:51 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, mszeredi@suse.cz
Subject: Re: [PATCH 4/6] vfs: set LOOKUP_JUMPED in follow_managed
Message-ID: <20120330023951.GA16140@ZenIV.linux.org.uk>
References: <1332759264-23533-1-git-send-email-miklos@szeredi.hu>
 <1332759264-23533-5-git-send-email-miklos@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332759264-23533-5-git-send-email-miklos@szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 12:54:22PM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> This is cleaner than if callers need to do it.

Except that I'd rather minimize passing nameidata pointers around...
