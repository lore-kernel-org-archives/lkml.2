Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab1A0JL5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 04:11:57 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49309 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654Ab1A0JLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 04:11:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=P4pYwfMcK5WVY4GpFsJTSCu5IcQQ1eg2J96EfsjcrH1TycMz7pWbi9DjOBEwKrL1bh
         2ActHb6PvteQmYe82vGIOMR2hqQlws91stOUTT0tNBMoAre1q9WVEvXFJQTel96LHoTe
         5147c6x0JvaETgx3ABixjQAG5tpxAIseLD0iA=
Subject: question for cpu voltage scaling in linux
From: mihn <mihnsk@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 Jan 2011 01:11:59 -0800
Message-ID: <1296119519.4653.3.camel@genix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sorry for posting cpufreq, linux-acpi as well.

I want to change voltage and frequency seperately.
With cpu-freq, i can change frequency, but cannot change voltage AFAIK.

Can I do this using cpu-freq?

If possible, how can I set voltage with the fixed value?
If not, is there any way to do that?

FYI, i'm using intel i7-core(nehalem) and ubuntu 10.10.
FYI2, i found out i can do using IA32_PERF_CTL register, but there's no
detail from intel.
FYI3, can i change P-state table so that i can only change voltage in P
states?

Thanks,
mihn


