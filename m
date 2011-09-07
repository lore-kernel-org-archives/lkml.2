Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab1IGFVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 01:21:16 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39028 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753910Ab1IGFVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 01:21:12 -0400
Date: Tue, 6 Sep 2011 22:21:00 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: =?iso-8859-1?Q?=C9ric?= Piel <eric.piel@tremplin-utc.net>,
        Ilkka Koskinen <ilkka.koskinen@nokia.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 1/2] lis3lv02d: Fix read() call in lis3lv02d_get_odr()
Message-ID: <20110907052057.GA2906@opensource.wolfsonmicro.com>
References: <1315293149-3881-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20110906140735.68ddbf42.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110906140735.68ddbf42.akpm@linux-foundation.org>
X-Cookie: Exercise caution in your daily affairs.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 06, 2011 at 02:07:35PM -0700, Andrew Morton wrote:

> This not applicable to mainline or to -stable.  It is a fix to
> lis3-remove-the-references-to-the-global-variable-in-core-driver.patch
> which I already have queued, as
> lis3-remove-the-references-to-the-global-variable-in-core-driver-fix.patch.

Hrm, strange - the fix doesn't seem to have shown up in -next before the
breakin.  Anyway, so long as it's fixed that's the main thing - thanks!
