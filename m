Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277Ab0KVVyB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 16:54:01 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43203 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932156Ab0KVVyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 16:54:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=A8mS0HTYI95WJFZb2vRlbpLCZup8c7S0leh3UE+L2USv+z9sI773Gb/oe4GrJqzlUR
         6A1UGnqz0EtgrZMN12g3XGmR0CUsTlGmCOCKKI5wfxxQ55oxeKrpMCz26n9dy/A3zcHo
         sY4GNiX9VDnzltQclyUqkVR1hSBRvE5fyce7Q=
MIME-Version: 1.0
In-Reply-To: <20101122140002.GB18960@rakim.wolfsonmicro.main>
References: <1290361223-15211-1-git-send-email-segoon@openwall.com>
	<20101122140002.GB18960@rakim.wolfsonmicro.main>
Date: Tue, 23 Nov 2010 06:53:58 +0900
Message-ID: <AANLkTimXOk8FXK5NqbuW9qa6HUt5_4Fgvc+7h8OrJO_j@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH] ASoC: s3c24xx: test wrong variable
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>, alsa-devel@alsa-project.org,
        Jassi Brar <jassi.brar@samsung.com>, Takashi Iwai <tiwai@suse.de>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Liam Girdwood <lrg@slimlogic.co.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 11:00 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Sun, Nov 21, 2010 at 08:40:21PM +0300, Vasiliy Kulikov wrote:
>> After clk_get() mclk is checked three times instead of mout_epll
>> and sclk_spdif checks.
>>
>> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
>
> Applied, thanks.

Wierd, it is CC to me as well but I didn't receive it.
Though the change is ok.
