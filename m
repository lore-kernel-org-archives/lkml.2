Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757732Ab2JJDJV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 23:09:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44905 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751623Ab2JJDJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 23:09:19 -0400
Date: Wed, 10 Oct 2012 12:09:07 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: gregkh@linuxfoundation.org, sameo@linux.intel.com, swarren@nvidia.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] mfd: tps65910: Initialize mfd devices after all
 initialization done
Message-ID: <20121010030906.GG17288@opensource.wolfsonmicro.com>
References: <1349782116-9757-1-git-send-email-ldewangan@nvidia.com>
 <1349782116-9757-4-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349782116-9757-4-git-send-email-ldewangan@nvidia.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 04:58:34PM +0530, Laxman Dewangan wrote:
> Add sub devices of tps65910 after all initialization like interrupt,
> clock etc. is done. This will make sure that require data gets
> initialized properly before sub devices probe's get called.

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

but isn't this needed as a bug fix and so shouldn't it be the first
patch in the series and go in for v3.7?
