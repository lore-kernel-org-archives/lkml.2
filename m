Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab1GAGT1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 02:19:27 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:17260 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751365Ab1GAGTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 02:19:25 -0400
Message-ID: <4E0D66E7.7070409@dsn.okisemi.com>
Date: Fri, 01 Jul 2011 15:19:19 +0900
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Christian Gmeiner <christian.gmeiner@gmail.com>
CC: Alexander Stein <alexander.stein@systec-electronic.com>,
        Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>, Qi Wang <qi.wang@intel.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        yong.y.wang@intel.com, joel.clark@intel.com, kok.howg.ewe@intel.com,
        toshiharu-linux@dsn.okisemi.com
Subject: Re: [PATCH] i2c-eg20t : Fix the issue of Combined R/W transfer mode
References: <1308813430-2697-1-git-send-email-tomoya-linux@dsn.okisemi.com> <201106230952.09286.alexander.stein@systec-electronic.com> <4E02FD74.8020503@dsn.okisemi.com> <BANLkTi=zDMnwX5xYFazM3qb17wa6yY4LZw@mail.gmail.com> <BANLkTi=y43pWQC9wxjSPCEbr47hTYbJF6w@mail.gmail.com>
In-Reply-To: <BANLkTi=y43pWQC9wxjSPCEbr47hTYbJF6w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/30 23:08), Christian Gmeiner wrote:
> I am studying the datasheet and the driver... hope to find out whats wrong.

Thank you for your report.
I will start analyze the issue next week.

-- 
tomoya
OKI SEMICONDUCTOR CO., LTD.
