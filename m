Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab1JMK5v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 06:57:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33864 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752440Ab1JMK5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 06:57:50 -0400
Date: Thu, 13 Oct 2011 11:57:48 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        alsa-devel@alsa-project.org
Subject: Re: [RFC][PATCH] ASoC: Suppress restore of default register values
 for lzo cache sync
Message-ID: <20111013105747.GE5193@opensource.wolfsonmicro.com>
References: <1318498113.2857.16.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318498113.2857.16.camel@phoenix>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 05:28:33PM +0800, Axel Lin wrote:
> Currently we do suppress restore of default register values for rbtree
> and flat cache sync.
> A couple users use this trick to avoid writing reset register while resume.
> Thus make lzo cache sync suppress restore of default register values,
> so we have consistent behavior for all types of cache sync.

Given that we never acquired any in tree users for the LZO cache it'd
probably be as well to just work on the regmap version and deprecate
this one - there's no users to move over and it'll save effort.
