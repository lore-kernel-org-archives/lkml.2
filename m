Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614Ab1I2OXV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 10:23:21 -0400
Received: from gate.crashing.org ([63.228.1.57]:51643 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754923Ab1I2OXH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 10:23:07 -0400
Subject: Re: [PATCH 3/4] p4080ds-dts: Add two rapidio ports and message units support
Mime-Version: 1.0 (Apple Message framework v1244.3)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1317263341-19010-3-git-send-email-Gang.Liu@freescale.com>
Date: Thu, 29 Sep 2011 09:23:11 -0500
Cc: <linuxppc-dev@lists.ozlabs.org>, Jin Qing <b24347@freescale.com>,
        r58472@freescale.com, r61911@freescale.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        B11780@freescale.com
Content-Transfer-Encoding: 8BIT
Message-Id: <5A0FD312-DC65-41FD-9930-A7591589CE60@kernel.crashing.org>
References: <1317263341-19010-1-git-send-email-Gang.Liu@freescale.com> <1317263341-19010-3-git-send-email-Gang.Liu@freescale.com>
To: Liu Gang <Gang.Liu@freescale.com>
X-Mailer: Apple Mail (2.1244.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 28, 2011, at 9:29 PM, Liu Gang wrote:

> Add two message units and number of ports according to the p4080 reference manual.
> 
> Signed-off-by: Li Yang <leoli@freescale.com>
> Signed-off-by: Jin Qing <b24347@freescale.com>
> Signed-off-by: Liu Gang <Gang.Liu@freescale.com>
> ---
> arch/powerpc/boot/dts/p4080ds.dts  |    4 +-
> arch/powerpc/boot/dts/p4080si.dtsi |   37 +++++++++++++++++++++++++++--------
> 2 files changed, 30 insertions(+), 11 deletions(-)

what about all the other .dts with SRIO nodes in them?

- k