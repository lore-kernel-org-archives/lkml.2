Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178Ab2C1Cpa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 22:45:30 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:60565 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756564Ab2C1Cp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 22:45:29 -0400
MIME-Version: 1.0
In-Reply-To: <1332834841-13925-1-git-send-email-paul.liu@linaro.org>
References: <1332834841-13925-1-git-send-email-paul.liu@linaro.org>
Date: Wed, 28 Mar 2012 10:45:27 +0800
Message-ID: <CAAQ0ZWRh30PhS_zDhG5U1s8vTjETNQ0auHa9oNRt+Pv4zeCN1Q@mail.gmail.com>
Subject: Re: [PATCH] Regulator: anatop-regulator: patching to device-tree
 property "reg".
From: Shawn Guo <shawn.guo@linaro.org>
To: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 March 2012 15:54, Ying-Chun Liu (PaulLiu) <paul.liu@linaro.org> wrote:
> From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
>
> Change "reg" to "anatop-reg-offset" due to there is a warning of handling no
> size field in reg.
>
> This patch also adds the missing device-tree binding documentation.
>
> Signed-off-by: Ying-Chun Liu (PaulLiu) <paul.liu@linaro.org>
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Liam Girdwood <lrg@ti.com>

Acked-by: Shawn Guo <shawn.guo@linaro.org>
