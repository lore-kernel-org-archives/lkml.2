Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab0EERbZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 13:31:25 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47287 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab0EERbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 13:31:22 -0400
Date: Wed, 5 May 2010 13:31:20 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dmitry Torokhov <dtor@vmware.com>
Cc: pv-drivers@vmware.com, Christoph Hellwig <hch@infradead.org>,
       Pankaj Thakkar <pthakkar@vmware.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [Pv-drivers] RFC: Network Plugin Architecture (NPA) for vmxnet3
Message-ID: <20100505173120.GA1752@infradead.org>
References: <20100504230225.GP8323@vmware.com> <20100505172316.GA25338@infradead.org> <201005051029.42052.dtor@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005051029.42052.dtor@vmware.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 10:29:40AM -0700, Dmitry Torokhov wrote:
> > We're not going to add any kind of loader for binry blobs into kernel
> > space, sorry.  Don't even bother wasting your time on this.
> > 
> 
> It would not be a binary blob but software properly released under GPL.
> The current plan is for the shell to enforce GPL requirement on the
> plugin code, similar to what module loaded does for regular kernel
> modules.

The mechanism described in the document is loading a binary blob
coded to an abstract API.

That's something entirely different from having normal modules for
the Virtual Functions, which we already have for various pieces of
hardware anyway.
