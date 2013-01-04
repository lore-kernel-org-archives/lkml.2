Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011Ab3ADTwv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 14:52:51 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:58519 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760Ab3ADTwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 14:52:49 -0500
Message-ID: <50E7330D.2060107@wwwdotorg.org>
Date: Fri, 04 Jan 2013 12:52:45 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: dmitry.torokhov@gmail.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, swarren@nvidia.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH 4/4] input: keyboard: tegra: remove default key mapping
References: <1357297330-28878-1-git-send-email-ldewangan@nvidia.com> <1357297330-28878-5-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1357297330-28878-5-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2013 04:02 AM, Laxman Dewangan wrote:
> Tegra KBC driver have the default key mapping for 16x8 configuration.
> The key mapping can be provided through platform data or through DT
> and the mapping varies from platform to platform, hence this default
> mapping is not so useful. Remove the default mapping to reduce the code
> lines of the driver.

Overall, I agree with the intent of this change, but I /think/ the
default keymap described here actually /is/ useful for the
Seaboard/Springbank platforms. I guess the KBC driver isn't in the
device tree for that (or any) board yet, so removing this keymap isn't
really a regression, but it would be nice if you could come up with a
change to add suitable keymaps to the device tree files too.
