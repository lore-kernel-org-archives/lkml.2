Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758427Ab2AFB3V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 20:29:21 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56771 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721Ab2AFB3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 20:29:20 -0500
Date: Fri, 6 Jan 2012 05:29:15 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Rhyland Klein <rklein@nvidia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 1/5 v2] drivers: power: Rename bq20z75 to sbs-battery
Message-ID: <20120106012915.GA27391@oksana.dev.rtsoft.ru>
References: <1323136249-4134-1-git-send-email-rklein@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1323136249-4134-1-git-send-email-rklein@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 05:50:45PM -0800, Rhyland Klein wrote:
> This driver for the bq20z75 implemented the register spec defined
> by the SBS standard. As this is not unique to this the TI part this
> was originally written for, we can generalize this driver to
> show its support for any SBS compliant battery.
> 
> Signed-off-by: Rhyland Klein <rklein@nvidia.com>

All five applied, thank you!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
