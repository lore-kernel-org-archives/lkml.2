Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397Ab1BGCZU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 21:25:20 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58131 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754293Ab1BGCZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 21:25:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=vKjhs6d1ovHkCkeZXECFjy6xd1UIGwhLKfuYBIuPD/ZWQAr0iIdpI+9GYAVUUqKmYk
         XRvBYSUsXEj6dQajIOFqXQfnfu8HIJWADWBWAlTPR26etnrQGPV9+mDQcfznU6SngIpD
         wgVoBM8W2Pe/rl9LrOlpK8xRMV7QvtAw7pQVg=
MIME-Version: 1.0
In-Reply-To: <1297033463-14577-1-git-send-email-lars@metafoo.de>
References: <1297033463-14577-1-git-send-email-lars@metafoo.de>
Date: Mon, 7 Feb 2011 11:25:17 +0900
Message-ID: <AANLkTinOHBA9YHyt8s1PgiJoDNpiOw8EZywt5kwJwTx-@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH 1/7] ASoC: neo1973_wm8753: Remove scenario
 management code.
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        Linux Samsung SoC <linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 7, 2011 at 8:04 AM, Lars-Peter Clausen <lars@metafoo.de> wrote:
> It has been proven to be inflexible to do scenario management in kernel space.
>
> Since actual neo1973 board support has not been merged in mainline and this
> patch has been in the neo1973 tree for some time now it should be safe to remove
> this functionality without breaking existing userspace.
>
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

All
Acked-by: Jassi Brar <jassi.brar@samsung.com>
