Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab2CCLNY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 06:13:24 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:60137 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130Ab2CCLNX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 06:13:23 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 2/3] regulator: max1586: Use DIV_ROUND_UP macro to calculate selector
References: <1330676454.31023.0.camel@phoenix>
	<1330676521.31023.1.camel@phoenix>
X-URL: http://belgarath.falguerolles.org/
Date: Sat, 03 Mar 2012 12:13:10 +0100
In-Reply-To: <1330676521.31023.1.camel@phoenix> (Axel Lin's message of "Fri,
	02 Mar 2012 16:22:01 +0800")
Message-ID: <87ipimszsp.fsf@free.fr>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/24.0.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Axel Lin <axel.lin@gmail.com> writes:

> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/regulator/max1586.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

Acked-by: Robert Jarzmik <robert.jarzmik@free.fr>

-- 
Robert
