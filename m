Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064Ab2ABL3l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 06:29:41 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47035 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751084Ab2ABL3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 06:29:37 -0500
Date: Mon, 2 Jan 2012 11:29:33 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "AnilKumar, Chimata" <anilkumar@ti.com>
Cc: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>
Subject: Re: [PATCH 1/2] MFD: TPS65217: Add new mfd device for TPS65217
Message-ID: <20120102112932.GA2899@opensource.wolfsonmicro.com>
References: <1324617679-14301-1-git-send-email-anilkumar@ti.com>
 <20111223104918.GD2834@opensource.wolfsonmicro.com>
 <331ABD5ECB02734CA317220B2BBEABC103FF03@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <331ABD5ECB02734CA317220B2BBEABC103FF03@DBDE01.ent.ti.com>
X-Cookie: You now have Asian Flu.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 02, 2012 at 09:48:40AM +0000, AnilKumar, Chimata wrote:

> I am discussing with hardware folks on what to do about this, but for
> now I will skip interpreting the CHIPID. I can print it out for reference
> though.

Logging for diagnostics is probably enough - it'll verify that register
access to the device and mean that the value is available if it's useful
for debugging problems.
