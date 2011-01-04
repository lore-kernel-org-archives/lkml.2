Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507Ab1ADUvN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 15:51:13 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58997 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab1ADUvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 15:51:11 -0500
Subject: Re: [PATCH] regulator: missing index in PTR_ERR() in
 isl6271a_probe()
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: roel kluin <roel.kluin@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4D1DF637.1060609@gmail.com>
References: <4D1DF637.1060609@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Jan 2011 20:51:06 +0000
Message-ID: <1294174266.3320.0.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-31 at 16:26 +0100, roel kluin wrote:
> The index is missing so the return is wrong.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>  drivers/regulator/isl6271a-regulator.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Applied.

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

