Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309Ab1GELiT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 07:38:19 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37646 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932242Ab1GELiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 07:38:16 -0400
MIME-Version: 1.0
In-Reply-To: <4E0D66E7.7070409@dsn.okisemi.com>
References: <1308813430-2697-1-git-send-email-tomoya-linux@dsn.okisemi.com>
 <201106230952.09286.alexander.stein@systec-electronic.com>
 <4E02FD74.8020503@dsn.okisemi.com> <BANLkTi=zDMnwX5xYFazM3qb17wa6yY4LZw@mail.gmail.com>
 <BANLkTi=y43pWQC9wxjSPCEbr47hTYbJF6w@mail.gmail.com> <4E0D66E7.7070409@dsn.okisemi.com>
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Date: Tue, 5 Jul 2011 13:37:56 +0200
Message-ID: <CAH9NwWf2Mr2tY_SU30etHzD0Ogqsg7sdPgR2pV7DQpBB-aFz0A@mail.gmail.com>
Subject: Re: [PATCH] i2c-eg20t : Fix the issue of Combined R/W transfer mode
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: Alexander Stein <alexander.stein@systec-electronic.com>,
        Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>, Qi Wang <qi.wang@intel.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        yong.y.wang@intel.com, joel.clark@intel.com, kok.howg.ewe@intel.com,
        toshiharu-linux@dsn.okisemi.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there a git repository with all i2c-eg20t patches, which are not
yet in mainline?

--
Christian Gmeiner, MSc
