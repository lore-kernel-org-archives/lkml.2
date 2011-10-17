Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513Ab1JQQmP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 12:42:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:15187 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001Ab1JQQmO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 12:42:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="63697806"
Subject: Re: [PATCH v3] dmaengine: add CSR SiRFprimaII DMAC driver
From: Vinod Koul <vinod.koul@intel.com>
To: Barry Song <21cnbao@gmail.com>
Cc: Barry Song <Barry.Song@csr.com>, Arnd Bergmann <arnd@arndb.de>,
        Rongjun Ying <rongjun.ying@csr.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        workgroup.linux@csr.com, Jassi Brar <jaswinder.singh@linaro.org>,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <CAGsJ_4x35qp+ELFY0vDX3PKSXhTe-POzqv+EO+jbB3ABxs_yrA@mail.gmail.com>
References: <1318844199-19303-1-git-send-email-Barry.Song@csr.com>
	 <1318859861.23438.137.camel@vkoul-udesk3>
	 <CAGsJ_4x35qp+ELFY0vDX3PKSXhTe-POzqv+EO+jbB3ABxs_yrA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Oct 2011 22:00:08 +0530
Message-ID: <1318869008.23438.146.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-17 at 22:45 +0800, Barry Song wrote:
> @numf: Number of frames in this template.
> @frame_size: Number of chunks in a frame i.e, size of sgl[].
> 
> frame_size==1 means prima2 only support 1 chunk. numf > 0 means
> ylen(line number -1) is at least 0 and frame number is at least 1. 
How about adding note in your driver for this

-- 
~Vinod

