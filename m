Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932218Ab1DLRbf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 13:31:35 -0400
Received: from cantor.suse.de ([195.135.220.2]:53839 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932180Ab1DLRbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 13:31:33 -0400
Date: Tue, 12 Apr 2011 10:23:12 -0700
From: Greg KH <gregkh@suse.de>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>,
        "stable-review@kernel.org" <stable-review@kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [014/105] x86-64, mm: Put early page table high
Message-ID: <20110412172312.GA10300@suse.de>
References: <20110412143549.416968403@clark.kroah.org>
 <alpine.DEB.2.00.1104121623410.22672@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1104121623410.22672@kaball-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 04:25:14PM +0100, Stefano Stabellini wrote:
> On Tue, 12 Apr 2011, Greg KH wrote:
> > 2.6.38-stable review patch.  If anyone has any objections, please let us know.
> > 
> 
> 
> this patch breaks Xen and there isn't even a fix upstream yet, so please
> do not backport it

Ok, now dropped, thanks for letting me know.

greg k-h
