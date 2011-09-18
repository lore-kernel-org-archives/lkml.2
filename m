Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271Ab1IRC2d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 22:28:33 -0400
Received: from 14.mo1.mail-out.ovh.net ([178.32.97.215]:43504 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752847Ab1IRC2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 22:28:31 -0400
X-Greylist: delayed 4223 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 Sep 2011 22:28:31 EDT
Date: Sun, 18 Sep 2011 02:47:55 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Leo Yan <leoy@marvell.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haojian Zhuang <hzhuang1@marvell.com>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: Re: [PATCH 2/2] ARM: mmp: add audio sram allocator
Message-ID: <20110918004755.GD16141@game.jcrosoft.org>
References: <1312167547-26740-1-git-send-email-leoy@marvell.com>
 <1312167547-26740-3-git-send-email-leoy@marvell.com>
 <20110915143857.GL28104@game.jcrosoft.org>
 <4E72A2A1.1020400@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E72A2A1.1020400@marvell.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 4963811215139908410
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -200
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeftddrfeeiucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmneculddquddttddm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09:13 Fri 16 Sep     , Leo Yan wrote:
> 
> 
> On 09/15/2011 10:38 PM, Jean-Christophe PLAGNIOL-VILLARD wrote:
> >On 10:59 Mon 01 Aug     , Leo Yan wrote:
> >>Implement the audio sram allocator with genalloc,
> >>so that can dynamically allocate the buffer
> >>to pcm devices as need.
> >>
> >>Signed-off-by: Leo Yan<leoy@marvell.com>
> >this can be more generic nad move to lib/genalloc.c
> 
> This is an older version, i have updated the patch same as you said.
> pls see below link for the latest patch:
> http://lists.arm.linux.org.uk/lurker/message/20110815.030920.2ad4227b.en.html
I take a look on it it's the same issue this is not mach specific

Best Regards,
J.
