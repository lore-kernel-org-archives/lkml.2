Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab1BNQbo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 11:31:44 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42451 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755917Ab1BNQbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 11:31:41 -0500
Date: Mon, 14 Feb 2011 16:31:39 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andres Salomon <dilinger@queued.net>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/17] mfd sharing support (v2, part 1)
Message-ID: <20110214163139.GE8226@opensource.wolfsonmicro.com>
References: <20110211175735.0d4258dc@queued.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110211175735.0d4258dc@queued.net>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 11, 2011 at 05:57:35PM -0800, Andres Salomon wrote:

> Here's my second attempt[0] of the MFD sharing.  Rather than go
> through with the whole thing, this is just the part which makes
> mfd_cells always available to MFD clients.  I'm planning to later 
> remove driver_data, and just use a (renamed) platform_data as a
> general cleanup, but for now..  Here's the first part.

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

though I didn't go and check for existing platform data users in the
affected drivers.
