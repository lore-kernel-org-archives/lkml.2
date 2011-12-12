Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab1LLQFI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 11:05:08 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55466 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751627Ab1LLQFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 11:05:07 -0500
Date: Tue, 13 Dec 2011 00:04:35 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] mfd: Correct revision display for WM1811 revision D
Message-ID: <20111212160433.GA13414@opensource.wolfsonmicro.com>
References: <1322671954-29177-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20111212151547.GK13952@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111212151547.GK13952@sortiz-mobl>
X-Cookie: You enjoy the company of other people.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 04:15:47PM +0100, Samuel Ortiz wrote:

> > I can fold this and other updates into the big regmap changes I posted
> > the other day if that's helpful?

> It seems you have quite many wm8994 patches on your mfd/wm8994 branch. It
> would probably make sense for you to carry them through the regmap changes. If
> that's fine with you, feel free to add my Acked-by to them.

Yup, quite a few - I'll merge them all with the regmap stuff, thanks!
