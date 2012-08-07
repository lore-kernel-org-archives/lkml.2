Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712Ab2HGRGa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 13:06:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59034 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753515Ab2HGRG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 13:06:29 -0400
Date: Tue, 7 Aug 2012 18:06:26 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Axel Lin <axel.lin@gmail.com>
Subject: Re: regulator: Policy for setting current limits
Message-ID: <20120807170626.GZ16861@opensource.wolfsonmicro.com>
References: <201208060127.57074.heiko@sntech.de>
 <20120806115632.GB16861@opensource.wolfsonmicro.com>
 <201208070119.35129.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201208070119.35129.heiko@sntech.de>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 01:19:34AM +0200, Heiko Stübner wrote:
> Am Montag, 6. August 2012, 13:56:33 schrieb Mark Brown:

> > Regulators should be tending to the maximum in the available range and
> > consumers should specify the widest range possible so both a and b.

> Is this true for all regulators (i.e. voltage and currency regulators)?

No, voltage regualtors should tend to the lowest voltage.
