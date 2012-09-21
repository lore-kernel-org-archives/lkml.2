Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab2IUFSL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 01:18:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38811 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab2IUFSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 01:18:09 -0400
Date: Thu, 20 Sep 2012 22:15:30 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: jenny.tc@intel.com, ramakrishna.pallala@intel.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] charger-manager: Update charger-manager to support
 various charging conditions
Message-ID: <20120921051530.GB31443@lizard>
References: <1345536359-25778-1-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1345536359-25778-1-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 05:05:59PM +0900, Chanwoo Choi wrote:
[...]
> Chanwoo Choi (5):
>   charger-manager: Disable battery charging when charger cable is
>     detached
>   charger-manager: Use replacement variable to check state of battery
>   charger-manager: Add support sysfs entry for charger
>   charger-manager: Check fully charged state of battery periodically
>   charger-manager: Support limit of maximum possible duration for
>     charging/discharging

Thanks a lot for your work!

Patches 1-2 and 4-5 applied. Patch 3 failed to build, so I guess
it will need some fixes and resend.

Cheers,
Anton.
