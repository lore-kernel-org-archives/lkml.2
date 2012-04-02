Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab2DBX2F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 19:28:05 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:59362 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778Ab2DBX2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 19:28:03 -0400
Date: Mon, 2 Apr 2012 16:27:50 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com, mingo@elte.hu,
        stable@vger.kernel.org
Subject: Re: Don't apply 9f022e54b8ea82d1ecdf3bd78d9ab9f44d6b0655 to stable
 please.
Message-ID: <20120402232750.GB17821@kroah.com>
References: <20120402224701.GA6961@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120402224701.GA6961@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2012 at 06:47:02PM -0400, Konrad Rzeszutek Wilk wrote:
> Hey Greg,
> 
> The git commit 9f022e54b8ea82d1ecdf3bd78d9ab9f44d6b0655 has CC stable@kernel.org
> but it breaks Xen - we are working to fix it in 3.4, but the fix for it
> does some architectual changes (136d249ef7dbf0fefa292082cc40be1ea864cbd6) that
> I don't know if you are comfortable putting in stable tree.
> 

I have no idea what that git commit id referrs to, as it's not in
Linus's tree at the moment.

Care to give me a subject?  diffstat?  Some kind of hint?

And note, you forgot to send this to the stable@vger.kernel.org list,
where the other stable kernel maintainers live, please do so next time.

thanks,

greg k-h
