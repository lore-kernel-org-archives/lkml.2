Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab2HFM0J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 08:26:09 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:46534 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756124Ab2HFM0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 08:26:06 -0400
MIME-Version: 1.0
In-Reply-To: <1344254930-8214-1-git-send-email-morbidrsa@googlemail.com>
References: <1344254930-8214-1-git-send-email-morbidrsa@googlemail.com>
Date: Mon, 6 Aug 2012 13:26:04 +0100
Message-ID: <CAJSP0QVoM2rmqjeehwgzBRhXr843bSuESc+8SrCSWKNDRuBU=A@mail.gmail.com>
Subject: Re: [PATCH] line6: pcm.c: Changed simple_strtoul to kstrtoint
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Johannes Thumshirn <morbidrsa@googlemail.com>
Cc: gregkh@linuxfoundation.org, grabner@icg.tugraz.at,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 6, 2012 at 1:08 PM, Johannes Thumshirn
<morbidrsa@googlemail.com> wrote:
> Changed call to simple_strtoul to kstrtoint in pcm_set_impulse_volume(...)
>
> Signed-off-by: Johannes Thumshirn <morbidrsa@googlemail.com>
> ---
>  drivers/staging/line6/pcm.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)

Reviewed-by: Stefan Hajnoczi <stefanha@gmail.com>
