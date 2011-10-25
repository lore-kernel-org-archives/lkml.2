Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab1JYHJt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 03:09:49 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:49299 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754337Ab1JYHJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 03:09:46 -0400
X-Sasl-enc: XHjXTYelNSAcIuUX2dGffoTE8Ng1Chr2H6oKhnYIeWxm 1319526585
Date: Tue, 25 Oct 2011 09:09:10 +0200
From: Greg KH <greg@kroah.com>
To: Jari Ruusu <jariruusu@users.sourceforge.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel.org tarball/patch signature files
Message-ID: <20111025070910.GA9639@kroah.com>
References: <4EA3F7C0.24E469C5@users.sourceforge.net>
 <20111023113727.GA24285@kroah.com>
 <4EA41FB7.CB5369CF@users.sourceforge.net>
 <20111025014911.GC22764@kroah.com>
 <4EA651ED.44FDE737@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EA651ED.44FDE737@users.sourceforge.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 09:06:37AM +0300, Jari Ruusu wrote:
> Greg KH wrote:
> > Also realize our constraints.  I don't want to, and in fact it's almost
> > impossible to, upload the 3 compressed tarballs over a large number of
> > internet connections that I have access to as I travel around the world.
> 
> How about signing just one compressed tarball/patch, and let other
> compressed versions be without signature files. Users who want to check
> signature will then download the one you signed.

That's no difference from what we are doing today if you think it
though.

greg k-h
