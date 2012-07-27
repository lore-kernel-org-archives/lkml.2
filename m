Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950Ab2G0Lht (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 07:37:49 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36224 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab2G0Lhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 07:37:48 -0400
MIME-Version: 1.0
In-Reply-To: <1343359050.1726.9033.camel@vkoul-udesk3>
References: <1341340409-9347-1-git-send-email-fabio.estevam@freescale.com>
	<1343359050.1726.9033.camel@vkoul-udesk3>
Date: Fri, 27 Jul 2012 08:37:48 -0300
Message-ID: <CAOMZO5DCEgjw1cyCV5nP-aoksboF2HFQ_emzSUXRCgGAGNuqUg@mail.gmail.com>
Subject: Re: [PATCH] dma: imx-dma: Fix kernel crash due to missing clock conversion
From: Fabio Estevam <festevam@gmail.com>
To: Vinod Koul <vinod.koul@linux.intel.com>
Cc: Fabio Estevam <fabio.estevam@freescale.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
        javier.martin@vista-silicon.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 12:17 AM, Vinod Koul <vinod.koul@linux.intel.com> wrote:

>> Reported-by: Javier Martin <javier.martin@vista-silicon.com>
>> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> Applied thanks (to fixes-for 3.7)

You mentioned that you would also copy stable. Would it be applied
into stable soon too?
