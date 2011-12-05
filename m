Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab1LEDLb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 22:11:31 -0500
Received: from mga02.intel.com ([134.134.136.20]:24031 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753818Ab1LEDLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 22:11:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="82845090"
Subject: Re: [PATCH] dmaengine/ste_dma40: allow fixed physical channel
From: Vinod Koul <vinod.koul@intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Narayanan G <narayanan.gopalakrishnan@stericsson.com>,
        linux-kernel@vger.kernel.org, linus.walleij@stericsson.com,
        Rabin Vincent <rabin.vincent@stericsson.com>
In-Reply-To: <CACRpkdZEnibk4feDEW3-noXouuyK84WJAFeFEKq=9TBfmyxNKQ@mail.gmail.com>
References: <1322661042-18645-1-git-send-email-narayanan.gopalakrishnan@stericsson.com>
	 <CACRpkdZEnibk4feDEW3-noXouuyK84WJAFeFEKq=9TBfmyxNKQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Dec 2011 08:39:43 +0530
Message-ID: <1323054583.30390.55.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-30 at 16:24 +0100, Linus Walleij wrote:
> On Wed, Nov 30, 2011 at 2:50 PM, Narayanan G
> <narayanan.gopalakrishnan@stericsson.com> wrote:
> 
> > Allow logical channels to specify the physical channel they want to use.
> > This is needed to avoid two peripherals operating on the same physical
> > channel during some special use-cases. (like mmc and usb during a
> > usb mass storage case).
Is there any progress on the dma client-device channle mapping work you
were planning on. I haven't anything on that?

-- 
~Vinod

