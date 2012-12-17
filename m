Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab2LQVoW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 16:44:22 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:39869 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215Ab2LQVoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 16:44:21 -0500
Message-ID: <50CF9233.3010506@wwwdotorg.org>
Date: Mon, 17 Dec 2012 14:44:19 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] ARM: tegra: add connection name for uart clock table
References: <1355746101-15291-1-git-send-email-ldewangan@nvidia.com> <1355746101-15291-3-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1355746101-15291-3-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2012 05:08 AM, Laxman Dewangan wrote:
> Add connection name "uart-clk" for the uart clock information.

Does the UART receive more than one clock, so that it actually cares
what the clock connection name is? If not, can we just drop this patch?
