Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595Ab2KUB0Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 20:26:25 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40819 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972Ab2KUB0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 20:26:24 -0500
Date: Tue, 20 Nov 2012 17:26:20 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Bryan Schumaker <bjschuma@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: [ 31/66] NFS: Wait for session recovery to finish before
 returning
Message-ID: <20121121012620.GF5381@kroah.com>
References: <20121115040939.016421011@linuxfoundation.org>
 <20121115040941.255779659@linuxfoundation.org>
 <1353082639.4867.89.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353082639.4867.89.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 04:17:19PM +0000, Ben Hutchings wrote:
> On Wed, 2012-11-14 at 20:10 -0800, Greg Kroah-Hartman wrote:
> > 3.6-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Bryan Schumaker <bjschuma@netapp.com>
> > 
> > commit 399f11c3d872bd748e1575574de265a6304c7c43 upstream.
> [...]
> 
> Also not applied to 3.0 and 3.4; here's my version for 3.2 which is
> probably usable for at least one of those.

Now applied, thanks.

greg k-h
