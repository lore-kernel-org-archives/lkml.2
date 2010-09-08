Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758519Ab0IHJGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 05:06:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56654 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751806Ab0IHJGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 05:06:53 -0400
Date: Wed, 8 Sep 2010 10:06:50 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jassi Brar <jassisinghbrar@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Jassi Brar <jassi.brar@samsung.com>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] spi/spi_s3c64xx: Fix timeout handling in
 wait_for_xfer()
Message-ID: <20100908090649.GA31253@rakim.wolfsonmicro.main>
References: <1283873872-8633-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <AANLkTi=6voS7WXcXgVTdK614W0Epy_Ehf5QzufErV2tD@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=6voS7WXcXgVTdK614W0Epy_Ehf5QzufErV2tD@mail.gmail.com>
X-Cookie: Crazee Edeee, his prices are INSANE!!!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 08, 2010 at 10:11:59AM +0900, Jassi Brar wrote:

> I have already submitted a patch a few days ago
> https://patchwork.kernel.org/patch/151941/
> (It's strange that Grant's id isn't there in the CC list, despite my writing it)

Ah, excellent.  Now I see patchwork there look to be some other things
sitting in patchwork which might be handy for me as well.
