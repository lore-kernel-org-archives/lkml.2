Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758969Ab1EMMd5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 08:33:57 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:63808 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758699Ab1EMMdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 08:33:55 -0400
Subject: Re: [PATCH] regulator: Fix memory leak in max8998_pmic_probe
 failure path
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1305269646.15846.4.camel@phoenix>
References: <1305269646.15846.4.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 May 2011 13:33:51 +0100
Message-ID: <1305290031.3202.4.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-13 at 14:54 +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/regulator/max8998.c |   22 +++++++++++++---------
>  1 files changed, 13 insertions(+), 9 deletions(-)
> 

Applied.

Liam

