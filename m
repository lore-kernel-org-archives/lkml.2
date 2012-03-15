Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031949Ab2COQwl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 12:52:41 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50135 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031783Ab2COQwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 12:52:38 -0400
Date: Thu, 15 Mar 2012 20:52:33 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        David Dajun Chen <dchen@diasemi.com>
Subject: Re: [PATCH 1/3] power_supply: da9052-battery: Add missing
 platform_set_drvdata
Message-ID: <20120315165231.GA11441@oksana.dev.rtsoft.ru>
References: <1326267824.15588.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1326267824.15588.2.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 03:43:44PM +0800, Axel Lin wrote:
> Add missing platform_set_drvdata in da9052_bat_probe.
> Otherwise, calling platform_get_drvdata in da9052_bat_remove returns NULL.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---

All three applied, thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
