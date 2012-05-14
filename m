Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab2ENIWe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 04:22:34 -0400
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:43853 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753336Ab2ENIWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 04:22:33 -0400
Message-ID: <1336983748.4898.0.camel@odin>
Subject: Re: [PATCH] regulator: core: Release regulator-regulator supplies
 on error
From: Liam Girdwood <lrg@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 14 May 2012 09:22:28 +0100
In-Reply-To: <1336930623-15921-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1336930623-15921-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-05-13 at 18:37 +0100, Mark Brown wrote:
> If we fail while registering a regulator make sure we release the supply
> for the regulator if there is one.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Acked-by: Liam Girdwood <lrg@ti.com>

