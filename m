Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932422Ab2JRWji (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 18:39:38 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:53290 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932248Ab2JRWjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 18:39:36 -0400
Message-ID: <50808526.1080504@wwwdotorg.org>
Date: Thu, 18 Oct 2012 16:39:34 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: linux@arm.linux.org.uk, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] ARM: tegra: Add slink controller base address
References: <1350557795-31487-1-git-send-email-ldewangan@nvidia.com> <1350557795-31487-2-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1350557795-31487-2-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2012 04:56 AM, Laxman Dewangan wrote:
> Add base address of all slink controller of Tegra20
> and tegra30.

Lets not add anything to iomap.h; we're trying to remove it. Instead,
just put the raw address in the AUXDATA; I assume that's the only place
these defines end up being used...
