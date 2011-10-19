Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab1JSI1a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 04:27:30 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:37200 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab1JSI11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 04:27:27 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E9E89F2.2060103@cam.ac.uk>
Date: Wed, 19 Oct 2011 09:27:30 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111003 Thunderbird/7.0.1
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Joe Perches <joe@perches.com>, Wolfram Sang <w.sang@pengutronix.de>,
        Andy Whitcroft <apw@canonical.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: checkpatch WARNING: patch prefix 'b' exists, appears to be a
 -p0 patch
References: <4E9D9558.7040705@cam.ac.uk> <alpine.DEB.2.00.1110181643450.8149@chino.kir.corp.google.com> <1318982469.7569.1.camel@Joe-Laptop> <alpine.DEB.2.00.1110181819110.12850@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1110181819110.12850@chino.kir.corp.google.com>
X-Enigmail-Version: 1.4a1pre
Content-Type: multipart/mixed;
 boundary="------------080904070906020708040205"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080904070906020708040205
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 10/19/11 02:27, David Rientjes wrote:
> On Tue, 18 Oct 2011, Joe Perches wrote:
> 
>>>> This started happening when I run checkpatch on pretty much anything.
>>>> triggered by the b in this snipped for example
>>>> diff --git a/arch/arm/mach-pxa/stargate2.c b/arch/arm/mach-pxa/stargate2.c
>>>> index 3f8d0af..62dc2a8 100644
>>>> --- a/arch/arm/mach-pxa/stargate2.c
>>>> +++ b/arch/arm/mach-pxa/stargate2.c
>>>> @@ -54,6 +54,8 @@
>>>>  #include <linux/mfd/da903x.h>
>>>> Anyone else seeing this or have a clue what the heck is going on?
>>
>> It's done this since:
>>
>> $ git log -1 1e85572697b348b1a126520349a29654f2ae6a12
>> commit 1e85572697b348b1a126520349a29654f2ae6a12
>> Author: Wolfram Sang <w.sang@pengutronix.de>
>> Date:   Tue Jan 6 14:41:24 2009 -0800
>>
>>     checkpatch: Add warning for p0-patches
>>     
> 
> Hmm, not sure how useful that is unless both prefixes ('a' and 'b') exist.
Sorry, I missed one detail. This warning is firing on every patch including
any I pull off mailing lists or produce with git format-patch

As you can imagine - this is rather tedious.

As a random example see the attached patch from yesterday.

Jonathan

--------------080904070906020708040205
Content-Type: message/rfc822;
 name="[PATCHv3 6_7] input_cma3000_d0x: Unwind reverse order of init.eml"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="[PATCHv3 6_7] input_cma3000_d0x: Unwind reverse order of ini";
 filename*1="t.eml"

Return-Path: <ricardo.ribalda@gmail.com>
Received: from ppsw-51.csi.cam.ac.uk (ppsw-51-intramail.csi.cam.ac.uk [192.168.128.151])
	 by cyrus-24.csi.private.cam.ac.uk (Cyrus v2.3.14) with LMTPA;
	 Tue, 18 Oct 2011 16:48:34 +0100
X-Sieve: CMU Sieve 2.3
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: score -2.7 from SpamAssassin-3.3.2-1162027 
 * -0.7 RCVD_IN_DNSWL_LOW RBL: Sender listed at http://www.dnswl.org/, low
 *      trust
 *      [209.85.214.52 listed in list.dnswl.dnsbl.ja.net]
 *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail provider
 *       (ricardo.ribalda[at]gmail.com)
 * -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
 *      [score: 0.0000]
 * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
 *      author's domain
 *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
 *      valid
 * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Received: from mail-bw0-f52.google.com ([209.85.214.52]:64241)
	by ppsw-51.csi.cam.ac.uk (mx.cam.ac.uk [131.111.8.148]:25)
	with esmtp (csa=unknown) id 1RGBu2-00027T-Yc (Exim 4.72) for jic23@cam.ac.uk
	(return-path <ricardo.ribalda@gmail.com>); Tue, 18 Oct 2011 16:48:34 +0100
Received: by mail-bw0-f52.google.com with SMTP id zs2so967469bkb.25
        for <jic23@cam.ac.uk>; Tue, 18 Oct 2011 08:48:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        bh=zIgzrrsjAWlxv4lE+rfuosIQZLWB2bpCOAKsEMHhaFY=;
        b=NUAu9URZEKlPm9GHieb5i3Y//opEMygXOGH/RjwbK1ITc9p+gCw/lTUf/4J6i1hBCw
         NmM2AMa0ITXM2a3rz5gH/f5DkiUfkHdXEd7AF80llVwNPjVPdroPYskJUF+S70CuzwE0
         /NZlU2EarbDezsFEdAtCqGeUk9fepVWT4r0Yo=
Received: by 10.204.144.198 with SMTP id a6mr2257601bkv.9.1318952910586;
        Tue, 18 Oct 2011 08:48:30 -0700 (PDT)
Received: from localhost (0x4dd4aed9.adsl.cybercity.dk. [77.212.174.217])
        by mx.google.com with ESMTPS id u18sm2657250bkn.6.2011.10.18.08.48.28
        (version=TLSv1/SSLv3 cipher=OTHER);
        Tue, 18 Oct 2011 08:48:29 -0700 (PDT)
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: dmitry.torokhov@gmail.com,
	sameo@linux.intel.com,
	peter.ujfalusi@ti.com,
	aghayal@codeaurora.org,
	david@hardeman.nu,
	Shubhrajyoti@ti.com,
	saaguirre@ti.com,
	jic23@cam.ac.uk,
	hemanthv@ti.com,
	linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCHv3 6/7] input/cma3000_d0x: Unwind reverse order of init
Date: Tue, 18 Oct 2011 17:48:05 +0200
Message-Id: <1318952886-835-7-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1318952886-835-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1318952886-835-1-git-send-email-ricardo.ribalda@gmail.com>


Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/input/misc/cma3000_d0x.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/misc/cma3000_d0x.c b/drivers/input/misc/cma3000_d0x.c
index bbda34c..96a46d4 100644
--- a/drivers/input/misc/cma3000_d0x.c
+++ b/drivers/input/misc/cma3000_d0x.c
@@ -459,8 +459,8 @@ EXPORT_SYMBOL(cma3000_init);
 
 void cma3000_exit(struct cma3000_accl_data *data)
 {
-	free_irq(data->irq, data);
 	input_unregister_device(data->input_dev);
+	free_irq(data->irq, data);
 	kfree(data);
 }
 EXPORT_SYMBOL(cma3000_exit);
-- 
1.7.7



--------------080904070906020708040205--
