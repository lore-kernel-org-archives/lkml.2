Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab1CZPyA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 11:54:00 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50187 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab1CZPx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 11:53:59 -0400
Subject: Re: [PATCH] ASoC: twl6040: Return -ENOMEM if
 create_singlethread_workqueue fails
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Misael Lopez Cruz <misael.lopez@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
In-Reply-To: <1301126038.7662.2.camel@phoenix>
References: <1301126038.7662.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 26 Mar 2011 15:53:55 +0000
Message-ID: <1301154835.3455.54.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-03-26 at 15:53 +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  sound/soc/codecs/twl6040.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 

Applied.

Thanks

Liam

