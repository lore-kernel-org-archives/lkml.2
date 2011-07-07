Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab1GGMhw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 08:37:52 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:9057 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754557Ab1GGMhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 08:37:51 -0400
Message-ID: <A103B14DCBE64935815497A3464F512F@hacdom.okisemi.com>
From: "Toshiharu Okada" <toshiharu-linux@dsn.okisemi.com>
To: "Takashi Iwai" <tiwai@suse.de>
Cc: <perex@perex.cz>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>, <qi.wang@intel.com>,
        <yong.y.wang@intel.com>, <joel.clark@intel.com>,
        <kok.howg.ewe@intel.com>, <tomoya-linux@dsn.okisemi.com>
References: <1309948067-9333-1-git-send-email-toshiharu-linux@dsn.okisemi.com><s5hhb6z3byw.wl%tiwai@suse.de><34CF59A8D33E40B6822498A23CD554E8@hacdom.okisemi.com> <s5hvcve1n40.wl%tiwai@suse.de>
Subject: Re: [PATCH] Add SoundCard driver for OKI SEMICONDUCTOR ML7213 IOH
Date: Thu, 7 Jul 2011 21:35:17 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5931
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6109
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Date: Thu, 07 Jul 2011 11:00:47 +0200
From: Takashi Iwai <tiwai@suse.de>
>>
>> Therefore, I am not considering about ASoC.
>> Do I need to fit this driver to an ASoC framework for an upstream?
>
>Yes, I guess this would be a better choice in your case.

Thank you for your comment.
>From now on, We study about ASoC.
If there are a document, a website, a driver, etc. which are referred, 
please tell us.
Why is choosing ASoS better?
Is it better to correspond to ASoC, when Audio Codec is unfixed?

Best Regards
Toshiharu Okada 

