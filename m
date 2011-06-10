Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526Ab1FJRuc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 13:50:32 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51235 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757455Ab1FJRua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 13:50:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=w2XO8wPhjcPG+bpzME3/D9HXG3cmqD9wHyt8oNfuNmEM210LfQq11/rbNzD075PcRU
         GwAYzWrtOm3rLf6Mi82y592ijHY7zh4aN60pSayew0R4/GVwDUHWPtdyJrX0eFCZkpTk
         JCJOG9NC033sxMjOlxsSeXr+/d55CwFuXjyY0=
MIME-Version: 1.0
In-Reply-To: <1307726331-28618-3-git-send-email-lars@metafoo.de>
References: <1307726331-28618-1-git-send-email-lars@metafoo.de> <1307726331-28618-3-git-send-email-lars@metafoo.de>
From: Mike Frysinger <vapier@gentoo.org>
Date: Fri, 10 Jun 2011 13:50:09 -0400
X-Google-Sender-Auth: zkDR6NirGoU_6_91BRxLcAGvp5c
Message-ID: <BANLkTind0CsOvybmE=AzqOCFxO0bOTb_-w@mail.gmail.com>
Subject: Re: [Device-drivers-devel] [PATCH 3/3] Blackfin: bf537: Stamp:
 Register adau1701 codec and ASoC machine driver
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        device-drivers-devel@blackfin.uclinux.org,
        uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

looks straightforward.  once the codec/machine driver get merged, i'll
run this through my Blackfin tree of course.
-mike
