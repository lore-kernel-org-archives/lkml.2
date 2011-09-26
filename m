Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571Ab1IZJNK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 05:13:10 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41847 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324Ab1IZJNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 05:13:08 -0400
MIME-Version: 1.0
In-Reply-To: <1316435596.344.132.camel@L-0761.kpit.com>
References: <1316435596.344.132.camel@L-0761.kpit.com>
From: Eric Miao <eric.miao@canonical.com>
Date: Mon, 26 Sep 2011 17:12:48 +0800
X-Google-Sender-Auth: fybq_x-B-z9Y0pvF7ziM7jOctf8
Message-ID: <CAMPhdO-jiY+JmgYFSO2JKiCO5KxN3L1YqA_WoOY+rnwkf3cumA@mail.gmail.com>
Subject: Re: [PATCH 01/11] MFD: DA9052/53 MFD core module v6
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: ashish.jangam@kpitcummins.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dajun <dajun.chen@diasemi.com>, sameo@openedhand.com,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 19, 2011 at 8:33 PM, ashishj3 <ashish.jangam@kpitcummins.com> wrote:
> The DA9052/53 is a highly integrated PMIC subsystem with supply domain flexibility
> to support wide range of high performance application.
>
> It provides voltage regulators, GPIO controller, Touch Screen, RTC, Battery
> control and other functionality.
>
> Signed-off-by: David Dajun Chen <dchen@diasemi.com>
> Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>

Looks good to me.

Acked-by: Eric Miao <eric.miao@linaro.org>
