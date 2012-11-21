Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826Ab2KUObT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 09:31:19 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:57772 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384Ab2KUObS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 09:31:18 -0500
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
In-Reply-To: <1353507795-3516-1-git-send-email-thomas.abraham@linaro.org>
References: <1353507795-3516-1-git-send-email-thomas.abraham@linaro.org>
Date: Wed, 21 Nov 2012 23:31:16 +0900
X-Google-Sender-Auth: Ru2Ztg5iIG5hhhB8HHknVmka2Fw
Message-ID: <CAJ0PZbT-RD_jMpAesm9aegjpfzsimN-hAUX3ck7vJBOHH7EV5A@mail.gmail.com>
Subject: Re: [PATCH] regulator: max8997: skip gpio dvs setup if not used
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com,
        linux-samsung-soc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 11:23 PM, Thomas Abraham
<thomas.abraham@linaro.org> wrote:
> If gpio based voltage selection for buck 1/2/5 are not used, then the execution
> of gpio dvs setup code during probe can be skipped completly.

Even if GPIO-DVS feature is turned off, you need to setup BUCKxDVS1 anyway.
Otherwise, you may get "unspecified" behavior from the BUCK1/2/5,
which may incur unstable system.


Cheers,
MyungJoo


-- 
MyungJoo Ham, Ph.D.
Mobile Software Platform Lab, DMC Business, Samsung Electronics
