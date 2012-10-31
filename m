Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934088Ab2JaBRZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 21:17:25 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52881 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932341Ab2JaBRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 21:17:23 -0400
Date: Tue, 30 Oct 2012 20:17:21 -0500
From: Nishanth Menon <nm@ti.com>
To: Mark Langsdorf <mark.langsdorf@calxeda.com>
CC: <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 5/6] power: export opp cpufreq functions
Message-ID: <20121031011721.GA30039@kahuna>
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com>
 <1351631056-25938-6-git-send-email-mark.langsdorf@calxeda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1351631056-25938-6-git-send-email-mark.langsdorf@calxeda.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16:04-20121030, Mark Langsdorf wrote:
$subject
PM / OPP:
Also adding info that this allows cpufreq drivers to be used as module
might be helpful.
> Signed-off-by: Mark Langsdorf <mark.langsdorf@calxeda.com>
> Cc: linux-pm@vger.kernel.org
Side note:
Applies on v3.7-rc3
on rafael's linux-next branch:
linux-next      2b7f449 Merge branch 'pm-opp-next' into linux-next
on git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git
needs a rebase as it probably conflicts with
https://patchwork.kernel.org/patch/1582091/

Otherwise, approach:
Acked-by: Nishanth Menon <nm@ti.com>

-- 
Regards,
Nishanth Menon
