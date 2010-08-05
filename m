Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932988Ab0HEVqM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 17:46:12 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:38299 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756989Ab0HEVqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 17:46:08 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6065"; a="49907625"
Subject: Re: [GIT PULL] Initial Tegra ARM support
From: Daniel Walker <dwalker@codeaurora.org>
To: Erik Gilling <konkers@google.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-tegra@vger.kernel.org
In-Reply-To: <AANLkTi=dcQrik=+5xfwbNo_w7WkTOKZiKAFYFhwzbS=_@mail.gmail.com>
References: <AANLkTi=dcQrik=+5xfwbNo_w7WkTOKZiKAFYFhwzbS=_@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Aug 2010 14:45:55 -0700
Message-ID: <1281044755.30969.8.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-05 at 14:10 -0700, Erik Gilling wrote:
>  arch/arm/Kconfig                               |   25 +-
>  arch/arm/Makefile                              |    1 + 

In the future could you please send changes to arch/arm/Kconfig and
arch/arm/Makefile to Russell .. That way there's no chance for conflicts
with other -next trees.

Daniel
-- 
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

