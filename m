Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab1K0Lac (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 06:30:32 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47087 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754236Ab1K0Laa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 06:30:30 -0500
Date: Sun, 27 Nov 2011 11:30:28 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Rajendra Nayak <rnayak@ti.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: Checking return value of
 of_get_regulator_init_data
Message-ID: <20111127113028.GF2896@opensource.wolfsonmicro.com>
References: <1322309959.6001.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322309959.6001.1.camel@phoenix>
X-Cookie: Exercise caution in your daily affairs.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 26, 2011 at 08:19:19PM +0800, Axel Lin wrote:
> of_get_regulator_init_data() may return NULL, thus
> check the return value to avoid NULL pointer dereference.

Applied, thanks.
