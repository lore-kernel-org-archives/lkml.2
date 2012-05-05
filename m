Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558Ab2EEM5f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 08:57:35 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:57539 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755327Ab2EEM5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 08:57:34 -0400
Date: Sat, 5 May 2012 05:56:09 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com,
        bruce.e.robertson@intel.com,
        "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
Subject: Re: [PATCH 1/4] power-supply: smb347-charger: convert to use
 module_i2c_driver()
Message-ID: <20120505125609.GB31577@lizard>
References: <1334566121-8243-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1334566121-8243-1-git-send-email-mika.westerberg@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 11:48:38AM +0300, Mika Westerberg wrote:
> This reduces the amount of boilerplate code in the driver and makes it a bit
> simpler.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> ---

This all looks great, all four patches applied now.

Thank you!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
