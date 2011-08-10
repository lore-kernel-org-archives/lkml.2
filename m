Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558Ab1HJE4G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 00:56:06 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58875 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750850Ab1HJE4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 00:56:04 -0400
Date: Wed, 10 Aug 2011 13:55:58 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the sound-asoc tree
Message-ID: <20110810045556.GB23625@opensource.wolfsonmicro.com>
References: <20110810102525.484fcdc69b5501ffd4b16928@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110810102525.484fcdc69b5501ffd4b16928@canb.auug.org.au>
X-Cookie: You will get what you deserve.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 10:25:25AM +1000, Stephen Rothwell wrote:

> After merging the sound-asoc tree, today's linux-next build (x86_64
> allmodconfig) failed like this:

Should be fixed now.
