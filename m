Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312Ab1EZJeI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 05:34:08 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53998 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752Ab1EZJeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 05:34:07 -0400
Message-ID: <4DDE1E8B.9060805@ti.com>
Date: Thu, 26 May 2011 10:34:03 +0100
From: Liam Girdwood <lrg@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] regulator: Use device platform_data to retrieve db8500
 platform bits
References: <20110526090827.GC20259@sortiz-mobl>
In-Reply-To: <20110526090827.GC20259@sortiz-mobl>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/05/11 10:08, Samuel Ortiz wrote:
> With the addition of a platform device mfd_cell pointer, MFD drivers
> can go back to passing platform data back to their sub drivers.
> This allows for an mfd_cell->mfd_data removal and thus keep the
> sub drivers MFD agnostic. This is mostly needed for non MFD aware
> sub drivers.
> 
> Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>

Acked-by: Liam Girdwood <lrg@ti.com>

