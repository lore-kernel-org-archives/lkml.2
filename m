Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab1K0Tq5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 14:46:57 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58415 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752878Ab1K0Tq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 14:46:56 -0500
Date: Sun, 27 Nov 2011 19:46:53 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Rajendra Nayak <rnayak@ti.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH v2] regulator: Avoid potential NULL dereference in
 reg_fixed_voltage_probe()
Message-ID: <20111127194653.GB25598@opensource.wolfsonmicro.com>
References: <1322395677.2799.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322395677.2799.1.camel@phoenix>
X-Cookie: Beware of low-flying butterflies.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 27, 2011 at 08:07:57PM +0800, Axel Lin wrote:
> of_get_fixed_voltage_config() may return NULL, return -ENOMEM in this case
> so we don't dereference NULL pointer.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied, thanks.
