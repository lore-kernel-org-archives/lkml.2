Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933246Ab2KEPht (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 10:37:49 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:41210 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932842Ab2KEPhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 10:37:42 -0500
Date: Mon, 5 Nov 2012 16:37:49 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        Richard Ems <richard.ems@cape-horn-eng.com>,
        Brian Walker <bwalker@nvidia.com>
Subject: Re: [ 243/262] NFS: Fix Oopses in nfs_lookup_revalidate and
 nfs4_lookup_revalidate
Message-ID: <20121105153749.GA4920@kroah.com>
References: <20120928182957.993484211@linuxfoundation.org>
 <20120928183027.108406252@linuxfoundation.org>
 <4FA345DA4F4AE44899BD2B03EEEC2FA9092A6B26@SACEXCMBX04-PRD.hq.netapp.com>
 <20121105082305.GC3730@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121105082305.GC3730@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2012 at 09:23:05AM +0100, Greg Kroah-Hartman wrote:
> On Sat, Nov 03, 2012 at 08:12:28PM +0000, Myklebust, Trond wrote:
> > On Fri, 2012-09-28 at 11:52 -0700, Greg Kroah-Hartman wrote:
> > > From: Greg KH <gregkh@linuxfoundation.org>
> > > 
> > > 3.5-stable review patch.  If anyone has any objections, please let me know.
> > 
> > 
> > Hi Greg,
> > 
> > Can we please apply this patch to the older stable kernels too? I see
> > that Ben has already applied it to the 3.2 kernel, but it really wants
> > to go into 3.4 and 3.0 as well...
> 
> Ok, I'll queue this up for the next round of releases.

Now applied, thanks.

greg k-h
