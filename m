Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129Ab1K0MDB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 07:03:01 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60383 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752852Ab1K0MDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 07:03:00 -0500
Date: Sun, 27 Nov 2011 12:02:58 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Rajendra Nayak <rnayak@ti.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: Avoid potential NULL dereference in
 reg_fixed_voltage_probe()
Message-ID: <20111127120258.GJ2896@opensource.wolfsonmicro.com>
References: <1322360030.6779.1.camel@phoenix>
 <20111127113529.GG2896@opensource.wolfsonmicro.com>
 <CAF+7xWk8f-qiodctY3U3FRJiohZzYNO4KaE7v5qi1C52HUySNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF+7xWk8f-qiodctY3U3FRJiohZzYNO4KaE7v5qi1C52HUySNg@mail.gmail.com>
X-Cookie: Exercise caution in your daily affairs.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 27, 2011 at 07:56:20PM +0800, Axel Lin wrote:

> Or do you prefer change it this way:

Yes, that looks sensible.
