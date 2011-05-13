Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759192Ab1EMMe6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 08:34:58 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35134 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759179Ab1EMMe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 08:34:56 -0400
Subject: Re: [PATCH] regulator: Fix desc_id for tps65023/6507x/65910
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Anuj Aggarwal <anuj.aggarwal@ti.com>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1305179270.11113.3.camel@phoenix>
References: <1305179270.11113.3.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 May 2011 13:34:52 +0100
Message-ID: <1305290092.3202.6.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-12 at 13:47 +0800, Axel Lin wrote:
> The desc_id variable should not be a static variable.
> 
> The rest of the code assumes the desc_id must less than TPSxxxxx_NUM_REGULATOR.
> If we set desc_id to be a static variable, checking the return value of
> rdev_get_id() may return error.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Cc: Anuj Aggarwal <anuj.aggarwal@ti.com>
> Cc: Graeme Gregory <gg@slimlogic.co.uk>


Applied.

Liam

