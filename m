Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab0IFTMI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 15:12:08 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36762 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab0IFTMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 15:12:05 -0400
Date: Mon, 6 Sep 2010 15:12:04 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Islam Amer <pharon@gmail.com>
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>, akpm@linux-foundation.org,
        stable@kernel.org
Subject: Re: Dell Studio 1555 eject key does not work ( small patch to fix
 included )
Message-ID: <20100906191204.GL2684@bombadil.infradead.org>
References: <AANLkTinG3jv6o8T00mDTEP5uxf4tKqOwSPEDIUcv4kVG@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinG3jv6o8T00mDTEP5uxf4tKqOwSPEDIUcv4kVG@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 01:14:09AM +0400, Islam Amer wrote:
> I had submitted this as
> https://bugzilla.kernel.org/show_bug.cgi?id=16075 but repeating the
> information and patch
> here as per Andrew Morton's suggestion.
> 

Thanks for sending this fix in, Islam. Adding stable@ to the Cc.

Greg, could you apply this to the stable tree as well? Should apply a
few releases back. We applied it to .34 and .35 in Fedora, at least.

The upstream commit id was d5164dbf1f651d1e955b158fb70a9c844cc91cd1.

regards, Kyle


