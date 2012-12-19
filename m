Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691Ab2LSRET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 12:04:19 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:52744 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754911Ab2LSREI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 12:04:08 -0500
Message-ID: <50D1F385.7000506@wwwdotorg.org>
Date: Wed, 19 Dec 2012 10:04:05 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: linux@arm.linux.org.uk, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: tegra30: tegra30 gpio is not compatible with tegra20
 gpio
References: <1355929032-26549-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1355929032-26549-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2012 07:57 AM, Laxman Dewangan wrote:
> tegra30 gpio controller is not compatible with the tegra20 due to
> their bank stride i.e. Tegra20 bank stride is 0x80 where Tegra30
> bank stride is 0x100.

Thanks, I've been meaning to clean this up for a while, but never got
around to it. I can apply after the merge window is closed; I don't
think it's important enough to warrant going into 3.8 or earlier, since
it doesn't cause any active problems.

Have you checked all the other devices to make sure they're all correct to?
