Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689Ab2INEtA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 00:49:00 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49131 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab2INEs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 00:48:59 -0400
Date: Thu, 13 Sep 2012 21:46:11 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, devel@driverdev.osuosl.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: nvec: adjust for mfd_add_devices() API change
Message-ID: <20120914044611.GA31082@kroah.com>
References: <1347467160-22724-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347467160-22724-1-git-send-email-swarren@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 10:26:00AM -0600, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> Commit 6607bad "mfd: core: Push irqdomain mapping out into devices"
> added a new parameter to mfd_add_devices(), but missed updating the
> nvec driver in staging.
> 
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Marc Dietrich <marvin24@gmx.de>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> --
> Samuel, I wonder if this patch should be squashed into the commit mentioned
> above in the MFD tree?

Looks good to me:

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
