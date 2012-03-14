Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761285Ab2CNR32 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 13:29:28 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35769 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756182Ab2CNR3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 13:29:25 -0400
Date: Wed, 14 Mar 2012 17:29:15 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Karol Lewandowski <k.lewandowsk@samsung.com>
Cc: ben-linux@fluff.org, thomas.abraham@linaro.org, m.szyprowski@samsung.com,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-samsung-soc@vger.kernel.org,
        t.stanislaws@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 2/3] i2c-s3c2410: Rework device type handling
Message-ID: <20120314172915.GB13393@sirena.org.uk>
References: <1331657679-31302-1-git-send-email-k.lewandowsk@samsung.com>
 <1331657679-31302-3-git-send-email-k.lewandowsk@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331657679-31302-3-git-send-email-k.lewandowsk@samsung.com>
X-Cookie: Be sure each item is properly endorsed.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 05:54:38PM +0100, Karol Lewandowski wrote:

>  - replace s3c24xx_i2c_type enum with plain unsigned int that can
>    hold not only device type but also hw revision-specific quirks

Would it not be clearer to just have explicit flags for the quirks (eg,
as a set of bitfield flags)?
