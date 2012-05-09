Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760713Ab2EISXF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 14:23:05 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53958 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab2EISXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 14:23:03 -0400
Date: Wed, 9 May 2012 19:23:01 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Yadwinder Singh <yadi.brar@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/2] regulator: add initial suport for max77686
Message-ID: <20120509182301.GA32037@sirena.org.uk>
References: <1336580695-1184-1-git-send-email-yadi.brar@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336580695-1184-1-git-send-email-yadi.brar@samsung.com>
X-Cookie: Now, let's SEND OUT for QUICHE!!
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 09:54:53PM +0530, Yadwinder Singh wrote:
> This patch series adds support for max77686 which is a multifunction device which
> includes regulator (pmic), rtc and charger sub-blocks within it. The support for
> mfd driver and regulator driver are added by this patch series. This patch series
> also includes device tree and irqdomain support for mfd and regulator portions.

Always CC maintainers on patches, please see SubmittingPatches.
