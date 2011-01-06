Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064Ab1AFAvI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:51:08 -0500
Received: from mga11.intel.com ([192.55.52.93]:34098 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754272Ab1AFAvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:51:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,280,1291622400"; 
   d="scan'208";a="874851539"
Date: Thu, 6 Jan 2011 00:25:33 +0000
From: Alan Cox <alan@linux.intel.com>
To: Russ Gorby <russ.gorby@intel.com>
Cc: <gregkh@suse.de>, <segoon@openwall.com>, <richardx.r.gorby@intel.com>,
        linux-kernel@vger.kernel.org, suhail.ahmed@intel.com
Subject: Re: [PATCH 3/7] serial: ifx6x60: changed internal bpw from boolean
 to int
Message-ID: <20110106002533.55c804f9@bob.linux.org.uk>
In-Reply-To: <1294272313-15899-4-git-send-email-russ.gorby@intel.com>
References: <[PATCH 0/7] IFX6X60 patchset: 01/05/2011>
	<1294272313-15899-4-git-send-email-russ.gorby@intel.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  5 Jan 2011 16:05:09 -0800
Russ Gorby <russ.gorby@intel.com> wrote:

> driver should support 32bit SPI transfers. The boolean variable
> only allowed 8/16.
> 
> Changed to support 8/16/32 for future enabling
> of 32 bpw.
> 
> Signed-off-by: Russ Gorby <russ.gorby@intel.com>


Acked-by: Alan Cox <alan@linux.intel.com>
