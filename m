Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580Ab1IVIXD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 04:23:03 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33570 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990Ab1IVIW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 04:22:58 -0400
Date: Thu, 22 Sep 2011 09:22:05 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Barry Song <21cnbao@gmail.com>
Cc: Jassi Brar <jassisinghbrar@gmail.com>, Piotr Ziecik <kosmo@semihalf.com>,
        Jaswinder Singh <jassi.brar@samsung.com>,
        Vinod Koul <vinod.koul@intel.com>, Pelagicore AB <info@pelagicore.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        Yong Wang <yong.y.wang@intel.com>, Barry Song <Baohua.Song@csr.com>,
        dan.j.williams@intel.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] dmaengine: delete redundant chan_id and chancnt
	initialization in dma drivers
Message-ID: <20110922082205.GI17169@n2100.arm.linux.org.uk>
References: <1316166200-20595-1-git-send-email-Baohua.Song@csr.com> <CABb+yY2L=wfRoascoriAcnNMKkV7LbQEHCpp78+rCY=aM46x7A@mail.gmail.com> <CAGsJ_4zURv1_zJ0rwZawa8VSOw0kT9U4-cCCj2Q4-BhV1pdTHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGsJ_4zURv1_zJ0rwZawa8VSOw0kT9U4-cCCj2Q4-BhV1pdTHA@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 08:08:44AM +0800, Barry Song wrote:
> actually i don't like the way dmaengine core handles chan_id. in my
> opinion, every dmac only needs to tell dmaengine core the chan_base.
> then dmaengine core set the id in a global scale.

Think about where we're heading with DT - with the description of the
hardware setup.  We're no longer interested in a global number from
0 to N.  We're more interested in per-device numbering.
