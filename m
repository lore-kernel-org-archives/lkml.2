Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758929Ab1FVVPB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 17:15:01 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34879 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758618Ab1FVVPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 17:15:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=lU9l9vZk77zKrdbokU93RI6d5oVvoNmqtizIe0LzYfa0lz2ipCZn+unUmEUqSkniRj
         NwMoyQG8DZ+WJkmcW2WQREWCPOl4qalSZbp1wZLM9tY4PrI3J6Ew/AyGOYFnl20+8hhD
         4ycyfOMIm+yoYWWELjKc/s+X3lN8WwzePe2Xg=
MIME-Version: 1.0
In-Reply-To: <1308776997-12959-1-git-send-email-lars@metafoo.de>
References: <1308776997-12959-1-git-send-email-lars@metafoo.de>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 22 Jun 2011 17:14:39 -0400
Message-ID: <BANLkTim5H3Qq2fjU3VM6xQvF3pXBpuwSDg@mail.gmail.com>
Subject: Re: [PATCH 1/4] ASoC: Add ADAV80x codec driver
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        device-drivers-devel@blackfin.uclinux.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

all look fine to me:
Acked-by: Mike Frysinger <vapier@gentoo.org>

the Blackfin one i'll run through my tree
-mike
