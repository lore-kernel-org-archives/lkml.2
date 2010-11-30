Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947Ab0K3Lcb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 06:32:31 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:59603 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144Ab0K3Lca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 06:32:30 -0500
Subject: Re: [PATCH] ASoC: Simplify pm860x_probe error handling
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
In-Reply-To: <1291102451.6929.1.camel@mola>
References: <1291102451.6929.1.camel@mola>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Nov 2010 11:32:25 +0000
Message-ID: <1291116745.3293.14.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-30 at 15:34 +0800, Axel Lin wrote:
> Simplify pm860x_probe error handling and return actual error code we got.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  sound/soc/codecs/88pm860x-codec.c |   12 +++++-------
>  1 files changed, 5 insertions(+), 7 deletions(-)

Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

