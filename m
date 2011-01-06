Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab1AFAyJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:54:09 -0500
Received: from mga03.intel.com ([143.182.124.21]:20620 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754171Ab1AFAyG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:54:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,280,1291622400"; 
   d="scan'208";a="370664904"
Date: Thu, 6 Jan 2011 00:29:03 +0000
From: Alan Cox <alan@linux.intel.com>
To: Russ Gorby <russ.gorby@intel.com>
Cc: <gregkh@suse.de>, <segoon@openwall.com>, <richardx.r.gorby@intel.com>,
        linux-kernel@vger.kernel.org, suhail.ahmed@intel.com
Subject: Re: [PATCH 6/7] serial: ifx6x60: fix modem names to ones recognized
 by firmware
Message-ID: <20110106002903.1f52e2e5@bob.linux.org.uk>
In-Reply-To: <1294272313-15899-7-git-send-email-russ.gorby@intel.com>
References: <[PATCH 0/7] IFX6X60 patchset: 01/05/2011>
	<1294272313-15899-7-git-send-email-russ.gorby@intel.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  5 Jan 2011 16:05:12 -0800
Russ Gorby <russ.gorby@intel.com> wrote:

> The current strings used in ID table are not correct and prevent
> protocol driver connecting to controller driver.
> Also, the indication of which modem h/w is present is not
> currently provided by the platform data.
> 
> Changed ifx_id_table[] to use strings recognized by platform firmware

No - the id table should be the actual I²C device names. The platform
code needs to do any name conversions from platform glue to standard
Linux naming.

Alan

