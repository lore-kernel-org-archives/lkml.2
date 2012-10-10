Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497Ab2JJDIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 23:08:00 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44892 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753290Ab2JJDH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 23:07:58 -0400
Date: Wed, 10 Oct 2012 12:07:44 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: gregkh@linuxfoundation.org, sameo@linux.intel.com, swarren@nvidia.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] mfd: tps65910: use regmap irq framework for
 interrupt support
Message-ID: <20121010030742.GE17288@opensource.wolfsonmicro.com>
References: <1349782116-9757-1-git-send-email-ldewangan@nvidia.com>
 <1349782116-9757-2-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349782116-9757-2-git-send-email-ldewangan@nvidia.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 04:58:32PM +0530, Laxman Dewangan wrote:
> Implement irq support of tps65910 with regmap irq framework
> in place of implementing locally.
> This reduces the code size significantly and easy to maintain.

Reviwed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
