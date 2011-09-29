Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263Ab1I2JnW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 05:43:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54046 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756217Ab1I2JnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 05:43:20 -0400
Date: Thu, 29 Sep 2011 10:43:18 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Subject: Re: linux-next: build failure after merge of the regmap tree
Message-ID: <20110929094318.GA3697@opensource.wolfsonmicro.com>
References: <20110929151841.1ee572099f6bc4db67138825@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110929151841.1ee572099f6bc4db67138825@canb.auug.org.au>
X-Cookie: You will be misunderstood by everyone.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 03:18:41PM +1000, Stephen Rothwell wrote:

> After merging the regmap tree, today's linux-next build (x86_64
> allmodconfig) failed like this:

Fixed now, thanks for reporting.
