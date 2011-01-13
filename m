Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274Ab1AMRSP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 12:18:15 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44091 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756855Ab1AMRSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 12:18:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=D0y3CLd7tVbNuyoRuKbXLzqp4UO6Gd+392oRw1oiz4tL/ZmS/zfkZqs77tkwwr/oQz
         1Jfo4IntxvO4kwPd5Zdphm4YzpzcWBWDC9zZhn4MAYBpO2Ui3v37FwtidLEiAsnQYGWD
         RM4OlnQY69mOH5ruwNkzKTi0raiB3DbW2iyss=
MIME-Version: 1.0
In-Reply-To: <20110113171249.GH30351@opensource.wolfsonmicro.com>
References: <1294805299-5265-1-git-send-email-vapier@gentoo.org>
 <20110113135525.GD11840@opensource.wolfsonmicro.com> <AANLkTi=5z0u3un8mGoFChMyzgeGY-tajr3iCC-aR6Dv6@mail.gmail.com>
 <20110113171249.GH30351@opensource.wolfsonmicro.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Thu, 13 Jan 2011 12:17:15 -0500
X-Google-Sender-Auth: WwJC1QbQ3OhaB7CMbwb9vmOToTY
Message-ID: <AANLkTi=Uf_uFT46fDrgQcwrwiO8GOGhxs_PZJEcG7XxY@mail.gmail.com>
Subject: Re: [uclinux-dist-devel] [PATCH] ASoC: Blackfin TDM: fix missed
 snd_soc_dai_get_drvdata update
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: uclinux-dist-devel@blackfin.uclinux.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 12:12, Mark Brown wrote:
> On Thu, Jan 13, 2011 at 11:52:02AM -0500, Mike Frysinger wrote:
>> On Thu, Jan 13, 2011 at 08:55, Mark Brown wrote:
>> > Ccing in Liam - Mike, please remember to CC maintainers on patches - and
>> > dropping the stable lists for now.
>>
>> i thought you were the ASoC maintainer
>
> We comaintain ASoC, we generally both review everything except during
> vacations.

np ... i'll update my .git/mail
-mike
