Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab1LTKDp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 05:03:45 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37240 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752070Ab1LTKDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 05:03:39 -0500
Date: Tue, 20 Dec 2011 10:03:10 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: da9052: Staticize non-exported symbols
Message-ID: <20111220100310.GB2866@opensource.wolfsonmicro.com>
References: <1324372320.16878.6.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324372320.16878.6.camel@phoenix>
X-Cookie: You enjoy the company of other people.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 05:12:00PM +0800, Axel Lin wrote:
> da9052_regulator_info and da9053_regulator_info are not used outside
> this driver so no need to make the symbol global.

Applied, thanks.
