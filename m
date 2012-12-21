Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066Ab2LUOPR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 09:15:17 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:61287 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab2LUOPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 09:15:09 -0500
MIME-Version: 1.0
In-Reply-To: <20121221110427.6e33bb9d@endymion.delvare>
References: <1355951171-3230-1-git-send-email-laurent.navet@gmail.com>
	<20121221110427.6e33bb9d@endymion.delvare>
Date: Fri, 21 Dec 2012 15:15:08 +0100
Message-ID: <CAH7P7NgXgu0HghZqaDObf++fcsTv3TG7K1mKPnTUGzF9egvraw@mail.gmail.com>
Subject: Re: [PATCH] drivers: i2c-nforce2: fix coding style issues
From: Laurent Navet <laurent.navet@gmail.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: w.sang@pengutronix.de, ben-linux@fluff.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This change causes a reject because __devinit was removed by another
> patch:
> http://git.pengutronix.de/?p=wsa/linux.git;a=commit;h=cda2826abea9a78d21b5e35d71db328657b756e5

i have tested that it applies cleanly on linux-next only, will try on
pengutronix.de/git/wsa/linux.git next time.

> It's an easy one. Please resubmit with the requested changes and then
> Wolfram can apply your patch. Thanks for the good work!
Regards,
