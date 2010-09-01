Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653Ab0IASjg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 14:39:36 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35413 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab0IASjf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 14:39:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=VSjSem4N3VWSuBcHK2sIRw3PKnPv8r/QFgzdGgbhzVhyhu+DTwg6lwO1A/Sm4ZYGQy
         gT09MMSXn+OfiPAtT8vOfAlXR9FsS1n9lwfyWInn6C8DXUpdPL1isyzgazNk1xqGRkRw
         7y5H0M4uElcEVuVqpCbEaF73htHjCHc/X9GUI=
MIME-Version: 1.0
In-Reply-To: <1283269738-14612-3-git-send-email-julia@diku.dk>
References: <1283269738-14612-1-git-send-email-julia@diku.dk> <1283269738-14612-3-git-send-email-julia@diku.dk>
From: Timur Tabi <timur@freescale.com>
Date: Wed, 1 Sep 2010 13:39:04 -0500
X-Google-Sender-Auth: mep7_LujqdEE6x4rBZJ_2PjK4M4
Message-ID: <AANLkTinpRVStYfHHaGTyLusMCjMQDH=MvcGVVKaxvHtN@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH 2/4] sound/soc/fsl/p1022_ds.c: Add
 of_node_put to avoid memory leak
To: Julia Lawall <julia@diku.dk>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org,
        Takashi Iwai <tiwai@suse.de>, devicetree-discuss@lists.ozlabs.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 10:48 AM, Julia Lawall <julia@diku.dk> wrote:
> Add a call to of_node_put in the error handling code following a call to
> of_parse_phandle.
>
> This patch also moves the existing call to of_node_put tothe end of the
> error handling code, to make it possible to jump to of_node_put without
> doing the other cleanup operations.  These appear to be disjoint
> operations, so the ordering doesn't matter.

Acked-by: Timur Tabi <timur@freescale.com>

Thanks, Julia.

-- 
Timur Tabi
Linux kernel developer at Freescale
