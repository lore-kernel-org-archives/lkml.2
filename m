Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467Ab2I0Dku (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 23:40:50 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59981 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952Ab2I0Dks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 23:40:48 -0400
Date: Wed, 26 Sep 2012 20:38:06 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: mathieu.poirier@linaro.org
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [PATCH 00/57] power: Upgrade to ux500 battery management driver
Message-ID: <20120927033806.GA22791@lizard>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 10:11:57AM -0600, mathieu.poirier@linaro.org wrote:
> From: "Mathieu J. Poirier" <mathieu.poirier@linaro.org>
> 
> This patch set upgrades the current ux500 battery management driver
> to the latest HW and functionality.
> 
> Pull request for convenience:
> 
> The following changes since commit 56d27adcb536b7430d5f8a6240df8ad261eb00bd:
> 
>   Merge git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile (2012-09-24 16:17:17 -0700)
> 
> are available in the git repository at:
> 
>   git://git.linaro.org/people/mpoirier/linux.git ux500-battery-management

I reviewed this series before, and all looked quite good overall. But I
took another look, especially at the patches w/ empty commit messages, and
there are some issues.

I tried to write some descriptions myself, but I failed: some changes are
not obvious to me, so I couldn't write rationale for them. :-/

Thanks,
Anton.
