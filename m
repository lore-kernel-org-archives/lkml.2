Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742Ab2JJDIY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 23:08:24 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44898 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753290Ab2JJDIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 23:08:22 -0400
Date: Wed, 10 Oct 2012 12:08:10 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: gregkh@linuxfoundation.org, sameo@linux.intel.com, swarren@nvidia.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] mfd: tps65910: move interrupt implementation code to
 mfd file
Message-ID: <20121010030808.GF17288@opensource.wolfsonmicro.com>
References: <1349782116-9757-1-git-send-email-ldewangan@nvidia.com>
 <1349782116-9757-3-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349782116-9757-3-git-send-email-ldewangan@nvidia.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 04:58:33PM +0530, Laxman Dewangan wrote:
> In place of implementing the irq support in separate file,
> moving implementation to main mfd file.
> The irq files only contains the table and init steps only
> and does not need extra file to have this only for this
> purpose.

Reviwed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
