Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965315Ab2J3SXi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 14:23:38 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33508 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759673Ab2J3SXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:23:34 -0400
Message-ID: <50901B24.9020904@wwwdotorg.org>
Date: Tue, 30 Oct 2012 12:23:32 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Dmitry Osipenko <digetx@gmail.com>
CC: swarren@nvidia.com, tiwai@suse.de, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: tegra: update spdif tx_atn_lvl on hw_params()
References: <1351607039-9027-1-git-send-email-digetx@gmail.com>
In-Reply-To: <1351607039-9027-1-git-send-email-digetx@gmail.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2012 08:23 AM, Dmitry Osipenko wrote:
> This prevents playing sound with wrong speed.

Reviewed-by: Stephen Warren <swarren@nvidia.com>

I guess this is fine, although as you say it makes little practical
difference in the mainline kernel; I'm sure there is much other work to
be done in order to support suspend/resume.
