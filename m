Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076Ab2IED2L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 23:28:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58141 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751191Ab2IED2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 23:28:09 -0400
Date: Wed, 5 Sep 2012 11:28:03 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, Greg KH <gregkh@linuxfoundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH -next] extcon: extcon-arizona depends on INPUT
Message-ID: <20120905032802.GB5076@opensource.wolfsonmicro.com>
References: <20120824172820.ee0f412d2944b08789414207@canb.auug.org.au>
 <5037B41C.6040703@xenotime.net>
 <503AB70E.2000407@samsung.com>
 <504693E4.8050808@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <504693E4.8050808@xenotime.net>
X-Cookie: Your lucky color has faded.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 04:51:00PM -0700, Randy Dunlap wrote:

> This build error still happens in linux-next of 20120904.

> Can we get the patch merged for linux-next?

Greg's the one managing extcon in -next.
