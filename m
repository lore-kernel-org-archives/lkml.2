Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab1C1NCa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 09:02:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:51806 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978Ab1C1NC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 09:02:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lukasz.Rymanowski@tieto.com
Subject: Re: [PATCH v2 1/2] staging: Add ST-Ericsson CG2900 driver
Date: Mon, 28 Mar 2011 15:02:05 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: tglx@linutronix.de, par-gunnar.p.hjalmdahl@stericsson.com, gregkh@suse.de,
        devel@driverdev.osuosl.org, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        pavan_savoy@sify.com, vitalywool@gmail.com, alan@lxorguk.ukuu.org.uk,
        marcel@holtmann.org, linus.walleij@stericsson.com, pghatwork@gmail.com,
        lee.jones@linaro.org, mathieu.poirier@linaro.org
References: <1301302950-10628-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com> <alpine.LFD.2.00.1103281110210.31464@localhost6.localdomain6> <7D7F2FD3846CF6429ACEBDFB5A2DD86F07E35E5F89@EXMB01.eu.tieto.com>
In-Reply-To: <7D7F2FD3846CF6429ACEBDFB5A2DD86F07E35E5F89@EXMB01.eu.tieto.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103281502.05203.arnd@arndb.de>
X-Provags-ID: V02:K0:HLW2vEwOVysldH7U59H32cg5AK4+sRgo2Fcr6vv5cGV
 2xhCxCP4m142KnrO6gRc51AqM6f6ZQIHOxsiAzf2qjc109mZ89
 dblNRl5vkiqbGgDP7yeXho3rC8lBojcVa3+qW7b7h6LPZzPCZe
 Wls+bRhwMoKoP5AMcdvzOozTdXcC2d17GyHNjNKMN0ObqjetI2
 Uxs4RYuflRIyZaaNHrVQg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 March 2011, Lukasz.Rymanowski@tieto.com wrote:
> >Have you thought about using a threaded interrupt handler?
> >That would make all this work cruft go away.
> 
> Good point.
> To be honest we did think about it but in the time we where we were busy with other issues.
> Anyway, shall we resend patches now or we can push patch for it once driver gets in the tree ?

No need to hold up merging because of this. Either patch it
once the code is in staging, or add a TODO file item.

	Arnd
