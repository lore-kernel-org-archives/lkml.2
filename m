Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170Ab0GFQtk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 12:49:40 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:29175 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167Ab0GFQtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 12:49:39 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6035"; a="46479058"
Subject: Re: [PATCH v2] msm: gpio: Add set_wake support to msm7200a-gpio's
 irq_chip.
From: Daniel Walker <dwalker@codeaurora.org>
To: Gregory Bean <gbean@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1278185128-29161-1-git-send-email-gbean@codeaurora.org>
References: <1278185128-29161-1-git-send-email-gbean@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Jul 2010 09:47:37 -0700
Message-ID: <1278434857.27490.2.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-07-03 at 12:25 -0700, Gregory Bean wrote:
> Add power-management and irq_chip hooks to allow configuration
> of msm-gpio irq lines as wakeup sources.
> 

What level of correlation is there between power management and the wake
up hooks? Just irq_masks ?

Daniel

