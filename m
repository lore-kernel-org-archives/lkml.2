Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187Ab1KZXxA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 18:53:00 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37337 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755073Ab1KZXw7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 18:52:59 -0500
MIME-Version: 1.0
In-Reply-To: <1322238658.6445.1.camel@phoenix>
References: <1322238658.6445.1.camel@phoenix>
From: Mike Frysinger <vapier@gentoo.org>
Date: Sat, 26 Nov 2011 18:52:36 -0500
X-Google-Sender-Auth: oz02xyb6orZqgbQgrg1xEdsquTA
Message-ID: <CAMjpGUeOYr=2rZHE6-H2Q5W2eLpJU_Q7yiBrut_JAHUENfttSg@mail.gmail.com>
Subject: Re: [PATCH] rtc: convert drivers/rtc/* to use module_platform_driver()
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Haojian Zhuang <haojian.zhuang@marvell.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Ben Dooks <ben@simtec.co.uk>,
        John Stultz <john.stultz@linaro.org>, rtc-linux@googlegroups.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 25, 2011 at 11:30, Axel Lin wrote:
>  drivers/rtc/rtc-bfin.c     |   13 +------------

Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike
