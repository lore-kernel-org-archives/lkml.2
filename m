Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724Ab1AKKsC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 05:48:02 -0500
Received: from mga09.intel.com ([134.134.136.24]:62084 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755694Ab1AKKru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 05:47:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,306,1291622400"; 
   d="scan'208";a="591804174"
Date: Tue, 11 Jan 2011 11:47:46 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Andres Salomon <dilinger@queued.net>
Cc: Jim Cromie <jim.cromie@gmail.com>, khali@linux-fr.org, ben-linux@fluff.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH] mfd: i2c: convert SCx200 driver from using raw PCI to
 platform device
Message-ID: <20110111104745.GC6616@sortiz-mobl>
References: <20101230202733.2f01b62d@queued.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101230202733.2f01b62d@queued.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andres,

On Thu, Dec 30, 2010 at 08:27:33PM -0800, Andres Salomon wrote:
> Note: this relies on the cs5535-mfd patches that are currently in the
> MFD next tree.  It's been tested on CS5536 hardware, but I don't have
> access to any old SCx200 hardware to verify that I didn't break the ISA
> stuff.
> 
Patch applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
