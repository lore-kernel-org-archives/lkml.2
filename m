Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918Ab2HHLQc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 07:16:32 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44049 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755838Ab2HHLQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 07:16:31 -0400
Date: Wed, 8 Aug 2012 12:16:29 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: Liam Girdwood <lrg@ti.com>, Axel Lin <axel.lin@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: gpio-regulator: Split setting of voltages and
 currents
Message-ID: <20120808111629.GM16861@opensource.wolfsonmicro.com>
References: <201208080050.20305.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201208080050.20305.heiko@sntech.de>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 12:50:19AM +0200, Heiko Stübner wrote:
> Originally gpio-regulator used the first item of its state list
> that matched the given voltage or current range.

Applied, thanks.
