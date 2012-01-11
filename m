Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198Ab2AKWWF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 17:22:05 -0500
Received: from mx.scalarmail.ca ([98.158.95.75]:21014 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758174Ab2AKWWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 17:22:02 -0500
Date: Wed, 11 Jan 2012 17:21:58 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>
Subject: Re: [00/40] 3.0.17-stable review
Message-ID: <20120111222158.GA20915@elliptictech.com>
References: <20120110214630.GA14384@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120110214630.GA14384@kroah.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On 2012-01-10 13:46 -0800, Greg KH wrote:
> This is the start of the stable review cycle for the 3.0.17 release.
> There are 40 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let us know.  If anyone is a maintainer of the proper subsystem, and
> wants to add a Signed-off-by: line to the patch, please respond with it.

These upstream commits (in 3.2):

  b7ea81a58adc ("ah: Read nexthdr value before overwriting it in ahash input callback.")
  069294e813ed ("ah: Correctly pass error codes in ahash output callback.")

made it into the 3.1.y series but they appear to not have made it into
3.0.y, where they're also applicable.  Also, the following one fixes a
real bug so it may be 3.0.y material, although I'm not sure if any
in-tree drivers can trigger it (this one requires a real ahash driver
for real hardware to trigger; unlike the previous two, cryptd won't do):

  4b90a603a1b2 ("ah: Don't return NET_XMIT_DROP on input")

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)

