Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999Ab0GUVCC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 17:02:02 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:61424 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754961Ab0GUVCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 17:02:00 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6050"; a="48206597"
Subject: Re: [PATCH 2/4] mm: cma: Contiguous Memory Allocator added
From: Daniel Walker <dwalker@codeaurora.org>
To: =?UTF-8?Q?Micha=C5=82?= Nazarewicz <m.nazarewicz@samsung.com>
Cc: linux-mm@kvack.org, Marek Szyprowski <m.szyprowski@samsung.com>,
        Pawel Osciak <p.osciak@samsung.com>,
        Xiaolin Zhang <xiaolin.zhang@intel.com>,
        Hiremath Vaibhav <hvaibhav@ti.com>,
        Robert Fekete <robert.fekete@stericsson.com>,
        Marcus Lorentzon <marcus.xm.lorentzon@stericsson.com>,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-arm-msm@vger.kernel.org
In-Reply-To: <op.vf7ofuif7p4s8u@pikus>
References: <cover.1279639238.git.m.nazarewicz@samsung.com>
	 <d6d104950c1391eaf3614d56615617cee5722fb4.1279639238.git.m.nazarewicz@samsung.com>
	 <adceebd371e8a66a2c153f429b38068eca99e99f.1279639238.git.m.nazarewicz@samsung.com>
	 <1279649724.26765.23.camel@c-dwalke-linux.qualcomm.com>
	 <op.vf5o28st7p4s8u@pikus>
	 <1279654698.26765.31.camel@c-dwalke-linux.qualcomm.com>
	 <op.vf6zo9vb7p4s8u@pikus>
	 <1279733750.31376.14.camel@c-dwalke-linux.qualcomm.com>
	 <op.vf7gt3qy7p4s8u@pikus>
	 <1279736348.31376.20.camel@c-dwalke-linux.qualcomm.com>
	 <op.vf7h1yc47p4s8u@pikus>
	 <1279738688.31376.24.camel@c-dwalke-linux.qualcomm.com>
	 <op.vf7j13067p4s8u@pikus>
	 <1279741029.31376.33.camel@c-dwalke-linux.qualcomm.com>
	 <op.vf7lipj67p4s8u@pikus>
	 <1279742604.31376.40.camel@c-dwalke-linux.qualcomm.com>
	 <op.vf7mvhvn7p4s8u@pikus>
	 <1279744472.31376.42.camel@c-dwalke-linux.qualcomm.com>
	 <op.vf7nuzu57p4s8u@pikus>
	 <1279745143.31376.46.camel@c-dwalke-linux.qualcomm.com>
	 <op.vf7ofuif7p4s8u@pikus>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Jul 2010 14:01:42 -0700
Message-ID: <1279746102.31376.47.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-07-21 at 22:56 +0200, Michał Nazarewicz wrote:
> On Wed, 21 Jul 2010 22:45:43 +0200, Daniel Walker <dwalker@codeaurora.org> wrote:
> > Your not hearing the issues.. IT'S TOO COMPLEX! Please remove it.
> 
> Remove what exactly?

Remove the command line option and all related code, or make it all a
debug option.

Arguing with me isn't going to help your cause.

Daniel

-- 
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

