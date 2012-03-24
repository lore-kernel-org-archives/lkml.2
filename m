Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab2CXOWO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 10:22:14 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:53742
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752319Ab2CXOWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 10:22:13 -0400
Date: Sat, 24 Mar 2012 10:22:12 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Christoph Hellwig <hch@infradead.org>, viro@ZenIV.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Trond.Myklebust@netapp.com, sfrench@samba.org, sage@newdream.net,
        ericvh@gmail.com
Subject: Re: [PATCH 13/25] cifs: implement i_op->atomic_open() and
 i_op->atomic_create()
Message-ID: <20120324142212.GD25980@infradead.org>
References: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
 <1331155362-11132-14-git-send-email-miklos@szeredi.hu>
 <20120313120649.GB27171@infradead.org>
 <878vj48vsr.fsf@tucsk.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878vj48vsr.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 02:39:16PM +0100, Miklos Szeredi wrote:
> Apparently CIFS is the only one that can tell whether the file was
> created or not.  If the flag is set then notify_create() is called.
> Users of NFS doesn't seem to care, it's of dubious value anyway, but why
> not use the info when available?

Given that *notify doesn't work correctly on non-local filesystes anyway
I don't think it matters.
