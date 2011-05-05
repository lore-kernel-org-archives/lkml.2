Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407Ab1EEO6b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 10:58:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753219Ab1EEO6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 10:58:30 -0400
Date: Thu, 5 May 2011 16:58:55 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org
Subject: -longterm kernels (Was: Re: [stable] Patch Upstream: iwlwifi: fix
 skb usage after free)
Message-ID: <20110505145854.GA4670@redhat.com>
References: <201105030110.p431A5W0005426@hera.kernel.org>
 <20110504223605.GA5967@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110504223605.GA5967@kroah.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Removing Cc as probably not interested, adding LKML)

On Wed, May 04, 2011 at 03:36:05PM -0700, Greg KH wrote:
> > Cc: stable@kernel.org # 2.6.32+
> 
> This doesn't apply to the .32 or .33-stable kernels.  If you wish to see
> it there, can someone please provide a backport and send it to
> stable@kernel.org ?
Done.

BTW, Greg, perhaps -logterm releasing policy should be revised somehow.
Currently we have .32, .33, .34, .35 -longterm, what is kind a much. If
I could suggest something, would be nice to have longterm chosen
versions predictable and constants i.e. one from every 3 kernel
releases, like .35, .38, .41 ... . That would make distributions, that
try to do release every half year very happy, because they will know
what kernel to choose, which will be widely supported and tested. Also
developers will have a bit less work with backporting fixes, as having
same bug in n and n-3 release is less probable, than having the same bug
in n and n-1.

Stanislaw
