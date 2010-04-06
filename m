Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab0DFKvm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 06:51:42 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46290 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751617Ab0DFKvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 06:51:35 -0400
Date: Tue, 6 Apr 2010 11:51:33 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Todd Fischer <todd.fischer@ridgerun.com>
Cc: linux-kernel@vger.kernel.org,
       davinci-linux-open-source@linux.davincidsp.com, sameo@linux.intel.com,
       lrg@slimlogic.co.uk
Subject: Re: [PATCH 0/4]-V3 TPS6507x MFD driver
Message-ID: <20100406105132.GC2688@rakim.wolfsonmicro.main>
References: <1270520639-20516-1-git-send-email-todd.fischer@ridgerun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1270520639-20516-1-git-send-email-todd.fischer@ridgerun.com>
X-Cookie: On the eighth day, God created FORTRAN.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 05, 2010 at 08:23:55PM -0600, Todd Fischer wrote:

> This is the third posting of the TPS6507x driver set.  I have
> resolved the concurrent access issue identified by Mark Brown.
> Instead of using a mutex, I used the i2c_transfer() as done in
> the similar routine in the wm8400-core.c file.

All

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

When reposting a patch series that has previously been reviewed it's
useful to record any acks and similar that were given for patches that
have been reposted unmodified - this makes life easier for reviewers
since it saves having to re-review previously posted patches.
