Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896Ab1EKSKz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 14:10:55 -0400
Received: from mga14.intel.com ([143.182.124.37]:47966 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430Ab1EKSKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 14:10:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,354,1301900400"; 
   d="scan'208";a="434450253"
Date: Wed, 11 May 2011 18:55:53 +0100
From: Alan Cox <alan@linux.intel.com>
To: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gma500: Skip bogus LVDS VBT mode and check for LVDS
 before adding backlight
Message-ID: <20110511185553.5260805f@bob.linux.org.uk>
In-Reply-To: <20110511172053.GA3557@patrik-macbook>
References: <20110511172053.GA3557@patrik-macbook>
Organization: Intel
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 May 2011 19:20:53 +0200
Patrik Jakobsson <patrik.r.jakobsson@gmail.com> wrote:

> On the Fit-PC2 the VBT reports an invalid fixed panel mode for LVDS,
> this gets in the way for SDVO. This patch makes VBT parsing skip the
> invalid mode. When there is no LVDS output the backlight support
> crashes so the patch also checks for this before enabling it.

Looks good for now. The backlight is a bit more complicated I think
(users can turn on the LVDS at runtime in theory) but we can handle
that later so long as we tag it with a /* FIXME: Handle turning on LVDS
at runtime */

Alan
