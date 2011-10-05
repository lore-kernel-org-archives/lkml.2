Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933996Ab1JEB7K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 21:59:10 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:26046 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933050Ab1JEB7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 21:59:08 -0400
Message-ID: <4E8BB9E7.9080104@dsn.lapis-semi.com>
Date: Wed, 05 Oct 2011 10:59:03 +0900
From: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ben Dooks <ben-i2c@fluff.org>
CC: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Qi Wang <qi.wang@intel.com>, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com
Subject: Re: [PATCH 3/7] i2c-eg20t: delete 10bit access processing
References: <1316591509-4433-1-git-send-email-tomoya-linux@dsn.okisemi.com> <1316591509-4433-3-git-send-email-tomoya-linux@dsn.okisemi.com> <20111004205536.GA13323@freya.fluff.org>
In-Reply-To: <20111004205536.GA13323@freya.fluff.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

(2011/10/05 5:55), Ben Dooks wrote:
> On Wed, Sep 21, 2011 at 04:51:45PM +0900, Tomoya MORINAGA wrote:
>> Linux I2C core doesn't support 10bit access formally.
>> Additionally, we can't test with 10bit mode.
>> This patch deletes the 10bit access processing.
>
> do we want to keep this patch in the series? if not, can
> you post a new series with this dropped from it?
>

Yes, I want to delete 10bit access process.
Or do you want to keep the 10bit code in i2c-eg20t.c ?
If you want, I can obey your opinion.

BTW, we found previous patch series was unsatisfactory.
So, we will post v2 patch series by today.

Thanks,

-- 
tomoya
ROHM Co., Ltd.
