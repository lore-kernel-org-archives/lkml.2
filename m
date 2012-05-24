Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933150Ab2EXKiq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 06:38:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52930 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755533Ab2EXKin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 06:38:43 -0400
Date: Thu, 24 May 2012 11:38:41 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] regmap: clean up debugfs if regmap_init fails
Message-ID: <20120524103840.GK5361@opensource.wolfsonmicro.com>
References: <1337812253-7564-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337812253-7564-1-git-send-email-swarren@wwwdotorg.org>
X-Cookie: You will get what you deserve.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 04:30:53PM -0600, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> If debugfs isn't cleaned up, stale files will be left in the filesystem
> which will cause an OOPS when accessed the first time, and hang the
> accessing application when accessed again, presumably due to some lock
> being left held.

Applied, thanks.
