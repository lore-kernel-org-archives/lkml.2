Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759469Ab2CNU2N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 16:28:13 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:43510 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755635Ab2CNU2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 16:28:09 -0400
Date: Wed, 14 Mar 2012 16:23:52 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Li Dongyang <lidongyang@novell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "JBeulich@suse.com" <JBeulich@suse.com>
Subject: Re: [Xen-devel] [PATCH] xen/blkback: Squash the discard support for
 'file' and 'phy' type.
Message-ID: <20120314202352.GC6251@phenom.dumpdata.com>
References: <1331679128-27646-1-git-send-email-konrad.wilk@oracle.com>
 <1331714035.4092.4.camel@dagon.hellion.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331714035.4092.4.camel@dagon.hellion.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A010201.4F60FF4D.004F,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 08:33:55AM +0000, Ian Campbell wrote:
> On Tue, 2012-03-13 at 22:52 +0000, Konrad Rzeszutek Wilk wrote:
> > The only reason for the distinction was for the special case of
> > 'file' (which is assumed to be loopback device)
> 
> Not related to this patch but how feasible would it be to make blkback
> able to cope with files directly?

Intersting thought. I am not sure... but an interesting thought. Would you
have Daniel's private email? We could email him for thoughts.
> 
> Ian.
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
