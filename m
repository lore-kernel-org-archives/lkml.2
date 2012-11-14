Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422842Ab2KNNDy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 08:03:54 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:42882 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422711Ab2KNNDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 08:03:53 -0500
Date: Wed, 14 Nov 2012 17:03:47 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Pavel Emelyanov <xemul@parallels.com>,
        Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com
Subject: Re: [patch 3/7] fs, notify: Add file handle entry into
 inotify_inode_mark
Message-ID: <20121114130347.GJ16685@moon>
References: <20121112101440.665694060@openvz.org>
 <2105540.yeyMVrW4mH@deuteros>
 <50A36ED5.4080505@parallels.com>
 <2092535.8S9EcgmZCZ@deuteros>
 <50A37692.1010500@parallels.com>
 <20121114124549.GB23604@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121114124549.GB23604@fieldses.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2012 at 07:45:49AM -0500, J. Bruce Fields wrote:
> > 
> > We can try going this route, what do you think?
> 
> I still don't understand why you need a dentry to get the filehandle.
> The current api may ask for one, but it shouldn't really be necessary
> (assuming you don't want parent directory information encoded in the
> filehandle, which I hope you don't).

As far as I know we don't need parent encoded. So Bruce, you think
to modify exportfs instead to work with inode directly?

	Cyrill
