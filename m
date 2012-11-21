Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab2KUBZ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 20:25:28 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63958 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab2KUBZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 20:25:26 -0500
Date: Tue, 20 Nov 2012 17:25:23 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Rhys <rhyspuk@gmail.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [ 21/66] drm/i915: fix overlay on i830M
Message-ID: <20121121012523.GE5381@kroah.com>
References: <20121115040939.016421011@linuxfoundation.org>
 <20121115040940.540633203@linuxfoundation.org>
 <1353082447.4867.88.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353082447.4867.88.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 04:14:07PM +0000, Ben Hutchings wrote:
> On Wed, 2012-11-14 at 20:10 -0800, Greg Kroah-Hartman wrote:
> > 3.6-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Daniel Vetter <daniel.vetter@ffwll.ch>
> > 
> > commit a9193983f4f292a82a00c72971c17ec0ee8c6c15 upstream.
> [...]
> 
> I notice you didn't apply this to 3.0 and 3.4.  I'm attaching the
> version I used for 3.2.

Now applied, thanks for the backport.

greg k-h
