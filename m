Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758241Ab1GDQGI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 12:06:08 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57699 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758181Ab1GDQGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 12:06:04 -0400
Subject: Re: [PATCH] regulator: max8997: remove dependency on platform_data
 pointer
From: Liam Girdwood <lrg@kernel.org>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, kyungmin.park@samsung.com,
        myungjoo.ham@gmail.com
In-Reply-To: <1308558617-20581-1-git-send-email-myungjoo.ham@samsung.com>
References: <1308558617-20581-1-git-send-email-myungjoo.ham@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Jul 2011 17:05:59 +0100
Message-ID: <1309795559.3272.8.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-20 at 17:30 +0900, MyungJoo Ham wrote:
> The platform_data (pdata) may be pointing to __initdata section, which
> may be free'd from the memory. The dependency on pdata in non-init
> functions is removed in this patch to allow platform to declare
> __initdata for platform data.
> 
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---

Applied.

Thanks

Liam

