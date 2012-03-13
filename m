Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760189Ab2CMJdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 05:33:10 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:48713
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759363Ab2CMJdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 05:33:09 -0400
Date: Tue, 13 Mar 2012 05:33:02 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        Trond.Myklebust@netapp.com, sfrench@samba.org, sage@newdream.net,
        ericvh@gmail.com, mszeredi@suse.cz
Subject: Re: [PATCH 05/25] vfs: add filesystem flags for atomic_open
Message-ID: <20120313093302.GA11797@infradead.org>
References: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
 <1331155362-11132-6-git-send-email-miklos@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331155362-11132-6-git-send-email-miklos@szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 10:22:22PM +0100, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Allow filesystem to select which cases it wants to perform atomic_open.

Given that atomic_open is allowed to return a NULL filp and fall back to
the traditional open I don't think this is needed - it can be much
cleaner handled by the fs just returning NULL for that case.

