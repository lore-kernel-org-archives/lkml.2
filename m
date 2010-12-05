Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab0LEHTy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 02:19:54 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43938 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676Ab0LEHTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 02:19:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=H3Q8CRj/4zaXFuxyjhGY8EMOWYktXxfN8awYQPx/yoYMcIsStDxRYuryh8669c4Nne
         eende8BAi0N+3NA7AbShSCBcsjdv1wpbBdZ6FPue33o/KwUbh9A2W+kNATW9j7jN5TX5
         6JO+FfEJHNS+Qdm/5ZgD3Pc07yH2Z2eBkYUE8=
MIME-Version: 1.0
From: nidhi mittal hada <nidhimittal19@gmail.com>
Date: Sun, 5 Dec 2010 12:49:31 +0530
Message-ID: <AANLkTik0SRGzo=nbs1z_9QyTwkYGvMQUK_6ShskKFe9u@mail.gmail.com>
Subject: beagle-board -high speed data acquisition from - adc --
To: Kernelnewbies <kernelnewbies@nl.linux.org>,
        linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-newbie@vger.kernel.org, mohit hada <mohit.soc@gmail.com>,
        vm.rod25@gmail.com, chambilkethakur@gmail.com,
        mensch0815@googlemail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all

Actually
I want to use a parallel interface ADC with the Beagle Board with 40Msps.
I want to take samples using 12 bit ADC and acquire it for say 100ms.

My input signal is 3 V p-p .


"Actually in my application after taking sample I want to calculate
4096 point FFT using it.
During this time i don't require to acquire input signal. Then the
calculated data has to
be passed to a PC using on board USB or UART interface.
Some more complex operations are also there such as correlations and
Principal Component analysis."

Please suggest whether beagle board is apt for such project.

My major concern is high speed acquisition using linux dvsdk from
Texas Instruments or any linux on beagleboard


Please help

--
Thanks & Regards
Nidhi Mittal Hada
Scientific officer D
Computer Division
Bhabha Atomic Research Center
Mumbai

http://nidhi-searchingmyself.blogspot.com/
