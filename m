Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759554Ab2CMTgc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 15:36:32 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:34459 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448Ab2CMTga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 15:36:30 -0400
Message-ID: <4F5FA1BB.5050002@wwwdotorg.org>
Date: Tue, 13 Mar 2012 13:36:27 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: Dmitry Artamonow <mad_soft@inbox.ru>
CC: Olof Johansson <olof@lixom.net>, Colin Cross <ccross@android.com>,
        Mike Rapoport <mike@compulab.co.il>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        linux-tegra@vger.kernel.org, Andi <andi.shyti@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm/tegra: pcie: fix return value of function
References: <CAOesGMi0aqCjLsJ5wWXwFVQL2T8wtUuE14rFZ9h7NKHXcWAoqQ@mail.gmail.com> <1331617587-10714-1-git-send-email-mad_soft@inbox.ru>
In-Reply-To: <1331617587-10714-1-git-send-email-mad_soft@inbox.ru>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2012 11:46 PM, Dmitry Artamonow wrote:
> In previous patch (arm/tegra: add timeout to PCIe PLL lock detection loop)
> tegra_pcie_enable_controller() function type has been changed from
> void to int, but the last return statement wasn't converted, so
> function returns undefined value. Fix it.
> 
> Also while at it, address couple of minor concerns raised by reviewers:
> use usleep_range for delay, and lower the value of timeout to 300ms
> to be consistent with Nvidia Vibrante kernel.
> 
> Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>

Acked-by: Stephen Warren <swarren@wwwdotorg.org>
