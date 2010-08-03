Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960Ab0HCKdA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 06:33:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:49528 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754253Ab0HCKc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 06:32:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,308,1278313200"; 
   d="scan'208";a="644211689"
Date: Tue, 3 Aug 2010 12:33:01 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Ian Molton <ian@mnementh.co.uk>
Subject: Re: [PATCH] tc6393xb: fix wrong goto labels for error handling
Message-ID: <20100803103300.GB2635@sortiz-mobl>
References: <1280805041.27646.1.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280805041.27646.1.camel@mola>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 11:10:41AM +0800, Axel Lin wrote:
> This patch corrects the error handling path.
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
