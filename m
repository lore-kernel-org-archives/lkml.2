Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758986Ab1FWIqx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 04:46:53 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:22485 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758942Ab1FWIqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 04:46:51 -0400
Message-ID: <4E02FD74.8020503@dsn.okisemi.com>
Date: Thu, 23 Jun 2011 17:46:44 +0900
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Alexander Stein <alexander.stein@systec-electronic.com>
CC: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>, Qi Wang <qi.wang@intel.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        yong.y.wang@intel.com, joel.clark@intel.com, kok.howg.ewe@intel.com,
        toshiharu-linux@dsn.okisemi.com
Subject: Re: [PATCH] i2c-eg20t : Fix the issue of Combined R/W transfer mode
References: <1308813430-2697-1-git-send-email-tomoya-linux@dsn.okisemi.com> <201106230952.09286.alexander.stein@systec-electronic.com>
In-Reply-To: <201106230952.09286.alexander.stein@systec-electronic.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/23 16:52), Alexander Stein wrote:
>
> Do you have any other local pending patches which are not in git yet? I can't
> find this for loop in current master.
>

I sent a patch for i2c-eg20t in 9-June which haven't been reviewed yet 
by i2c maintainer.

-- 
tomoya
OKI SEMICONDUCTOR CO., LTD.
