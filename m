Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab2ACQVZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 11:21:25 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:39692 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754129Ab2ACQVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 11:21:21 -0500
X-Sasl-enc: HDSrXf1M1iAcjOGD2sSqrB686+eIOdfDAGNauhDiLbre 1325607680
Date: Tue, 3 Jan 2012 08:21:08 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: linux-next: build failure after merge of the driver-core tree
Message-ID: <20120103162108.GC25909@kroah.com>
References: <20111228174518.721624fad9d048f9f85b3d50@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111228174518.721624fad9d048f9f85b3d50@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 28, 2011 at 05:45:18PM +1100, Stephen Rothwell wrote:
> Because of the powerpc problems above, I have used the driver-core tree
> from next-20111222 for today.

Sorry about all of the problems, we tried to fix everything we could,
but your merges and cross-builds found stuff we missed :(

Kay, care to send me patches to fix this, and all of the other
linux-next-reported problems to me so we can get this resolved this
week?

thanks,

greg k-h
