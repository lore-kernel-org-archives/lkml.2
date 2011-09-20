Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939Ab1ITKFp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 06:05:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44980 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751483Ab1ITKFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 06:05:44 -0400
Date: Tue, 20 Sep 2011 11:05:42 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@au1.ibm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: linux-next: manual merge of the regmap tree with the mfd tree
Message-ID: <20110920100542.GC2387@opensource.wolfsonmicro.com>
References: <20110920154218.27c270321f7b24d6b2a8d862@au1.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110920154218.27c270321f7b24d6b2a8d862@au1.ibm.com>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 03:42:18PM +1000, Stephen Rothwell wrote:

> I am not sure of the resolution here, so I just used the regmap tree
> version (which drops the shutdown member of wm8311_spi_driver added in
> the mfd version).

The shutdown member should be added.  I'll cherry pick the shutdown
change over into my branch which should resolve the issue.
