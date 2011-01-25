Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559Ab1AYBo3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 20:44:29 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45065 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab1AYBo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 20:44:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=JDc+cP1S0MaFWTI9LF3OYK8eK1Wo9PJNgvRitzkP8HYnRegUhJDaP+rdHYu8YiWh9q
         HLybYMiiQ2SHHQJjIkW5qTJ8mVVtJ17C7AI0djiok4d/R56YUayzSrhCcZrLwUd3YAf5
         rlQy1Devyfve5nPUmLzQfpRp0tVewRNw9yIA4=
MIME-Version: 1.0
In-Reply-To: <1295903562-4564-1-git-send-email-lars@metafoo.de>
References: <1295903363-4433-1-git-send-email-lars@metafoo.de>
	<1295903562-4564-1-git-send-email-lars@metafoo.de>
Date: Tue, 25 Jan 2011 10:44:26 +0900
Message-ID: <AANLkTino6vc5h7MrxZTkxcpXba3TZedrD+70F49VOAPA@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH 2/2] SoC: Samsung: Fix outdated cpu_dai_name
 for s3c24xx i2s
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 6:12 AM, Lars-Peter Clausen <lars@metafoo.de> wrote:
> During the multi-component patch the s3c24xx i2s driver was renamed from
> "s3c24xx-i2s" to "s3c24xx-iis", while the sound board drivers were not
> updated to reflect this change as well.
>
> As a result there is no match between the dai_link and the i2s driver and no
> sound card is instantiated.
>
> This patch fixes the problem by updating the sound board drivers to use
> "s3c24xx-iis" for the cpu_dai_name.
>
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

Acked-by: Jassi Brar <jassi.brar@samsung.com>
