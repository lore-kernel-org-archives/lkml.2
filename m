Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933106Ab2JSXBH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 19:01:07 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:58717 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755684Ab2JSXBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 19:01:04 -0400
Date: Fri, 19 Oct 2012 16:00:59 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: AnilKumar Ch <anilkumar@ti.com>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, dgdunix@gmail.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 1/2] Input: matrix-keypad - remove const from pointer to
 array of gpios
Message-ID: <20121019230059.GB10915@core.coreip.homeip.net>
References: <1350630373-24279-1-git-send-email-anilkumar@ti.com>
 <1350630373-24279-2-git-send-email-anilkumar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350630373-24279-2-git-send-email-anilkumar@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 12:36:12PM +0530, AnilKumar Ch wrote:
> Remove const from pointer to array of gpios in matrix_keypad_platform_data
> struct. This is required if we update row_gpios and col_gpios based on
> device tree data.

Then don't. Set them up via non-const aliases instead.

Thanks.

-- 
Dmitry
