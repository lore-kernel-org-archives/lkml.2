Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191Ab2LFGVM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 01:21:12 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43351 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932125Ab2LFGVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 01:21:11 -0500
Date: Thu, 6 Dec 2012 15:21:03 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Graeme Gregory <gg@slimlogic.co.uk>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFT][PATCH 1/2] regulator: palmas: Return raw register values
 as the selectors in [get|set]_voltage_sel
Message-ID: <20121206062102.GF10867@opensource.wolfsonmicro.com>
References: <1354154356.10511.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354154356.10511.2.camel@phoenix>
X-Cookie: Exercise caution in your daily affairs.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 09:59:16AM +0800, Axel Lin wrote:
> Don't adjust the selector in [get|set]_voltage_sel, fix it in list_voltage() instead.

Applied both, thanks.
