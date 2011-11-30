Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167Ab1K3XvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 18:51:18 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52975 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533Ab1K3XvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 18:51:15 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6546"; a="142448063"
Date: Wed, 30 Nov 2011 15:51:10 -0800
From: David Brown <davidb@codeaurora.org>
To: Cong Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>, Chris Ball <cjb@laptop.org>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, Alex Dubov <oakad@yahoo.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Ian Molton <ian@mnementh.co.uk>, linux-arm-kernel@lists.infradead.org,
        linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 20/62] mmc: remove the second argument of
 k[un]map_atomic()
Message-ID: <20111130235110.GA27283@huya.qualcomm.com>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>
 <1322371662-26166-21-git-send-email-amwang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322371662-26166-21-git-send-email-amwang@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 27, 2011 at 01:27:00PM +0800, Cong Wang wrote:

>  drivers/mmc/host/msm_sdcc.c |    6 +++---

Acked-by: David Brown <davidb@codeaurora.org>

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
