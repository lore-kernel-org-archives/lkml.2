Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616Ab2JJGte (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 02:49:34 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:46193 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab2JJGt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 02:49:27 -0400
Message-ID: <50751A67.2000800@ti.com>
Date: Wed, 10 Oct 2012 12:19:11 +0530
From: Afzal Mohammed <x0148406@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Vaibhav Hiremath <hvaibhav@ti.com>
CC: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Afzal Mohammed <afzal@ti.com>, Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH] ARM: OMAP2+: gpmc: Fix kernel BUG for DT boot mode
References: <1349773040-8204-1-git-send-email-hvaibhav@ti.com>
In-Reply-To: <1349773040-8204-1-git-send-email-hvaibhav@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 09 October 2012 02:27 PM, Vaibhav Hiremath wrote:

> This patch adds of_have_populated_dt() check before creating

> Signed-off-by: Vaibhav Hiremath<hvaibhav@ti.com>
> Cc: Afzal Mohammed<afzal@ti.com>

Reviewed-by: Afzal Mohammed <afzal@ti.com>
