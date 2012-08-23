Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab2HWCAz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 22:00:55 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:51503 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab2HWCAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 22:00:52 -0400
Date: Wed, 22 Aug 2012 18:58:28 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] power_supply: Add new power supply VALID property
Message-ID: <20120823015828.GB24471@lizard>
References: <1343532714-28040-1-git-send-email-ramakrishna.pallala@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1343532714-28040-1-git-send-email-ramakrishna.pallala@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 29, 2012 at 09:01:54AM +0530, Ramakrishna Pallala wrote:
> It is possible that users can use non-standard chargers
> or use invalid batteries especially with mobile devices.

Maybe 'original' or 'authentic' would be a better term for this?
For me, 'valid' is kind of too broad and confusing. :-/

[...]
> +VALID - indicates the power supply connected is valid(1) or invalid(0)
> +

But if you still think that 'valid' is a better term, can you please
document it in more detail?

Thanks!

Anton.
