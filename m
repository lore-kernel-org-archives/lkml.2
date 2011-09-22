Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751361Ab1IVANw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 20:13:52 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:44917 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751059Ab1IVANv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 20:13:51 -0400
Message-ID: <4E7A7DBA.3020406@dsn.okisemi.com>
Date: Thu, 22 Sep 2011 09:13:46 +0900
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Jeffrey (Sheng-Hui) Chu" <jeffchu@broadcom.com>
CC: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Qi Wang <qi.wang@intel.com>,
        "yong.y.wang@intel.com" <yong.y.wang@intel.com>,
        "joel.clark@intel.com" <joel.clark@intel.com>,
        "kok.howg.ewe@intel.com" <kok.howg.ewe@intel.com>,
        "toshiharu-linux@dsn.okisemi.com" <toshiharu-linux@dsn.okisemi.com>
Subject: Re: [PATCH 3/7] i2c-eg20t: delete 10bit access processing
References: <1316591509-4433-1-git-send-email-tomoya-linux@dsn.okisemi.com> <1316591509-4433-3-git-send-email-tomoya-linux@dsn.okisemi.com> <B6A520E9CD57404AAFC0831E4FB39541A98073AC7E@IRVEXCHCCR02.corp.ad.broadcom.com>
In-Reply-To: <B6A520E9CD57404AAFC0831E4FB39541A98073AC7E@IRVEXCHCCR02.corp.ad.broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/09/22 0:42), Jeffrey (Sheng-Hui) Chu wrote:

 > There is i2c device coming out that uses 10-bit address.
Thank you for your information.
We want to test 10-bit mode using the device.
So let me know the device information ?

Anyway, Now, kernel i2c-core is EXPERIMENTAL stage for 10-bit mode like 
below.

   (Documentation/i2c/ten-bit-addresses)
    WARNING! The current 10 bit address support is EXPERIMENTAL. There
   are several places in the code that will cause SEVERE PROBLEMS with
   10 bit addresses, even though there is some basic handling and
   hooks. Also,
   almost no supported adapter handles the 10 bit addresses correctly.

   As soon as a real 10 bit address device is spotted 'in the wild', we
   can and will add proper support. Right now, 10 bit address devices
   are defined by the I2C protocol, but we have never seen a single
   device which supports them.

After kernel supports 10bit-mode formally, we will add the function  to 
i2c-eg20t again.

Thanks,
tomoya
