Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab0EJQwY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 12:52:24 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50593 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755347Ab0EJQwT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 12:52:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=h97nML2PUDH/3lMmrZkYnMCgK/KKofc8LOJ2aNmEAnU4mVxFFLVDUS6yOHXjc5HMAF
         u9uOlfGoEHdawd6Ihd/Zt8EXfP2vaAebhJo0x0O+/peKP/zG1QfaCI9R2e438vKNYNFo
         b0wUxNkblPPNf6ZfERcdebD4H7HOj/JVLOfAY=
MIME-Version: 1.0
In-Reply-To: <AANLkTiny2Vk3y5DGYWEphQ94_HbgMUEZB1uub08WWs4w@mail.gmail.com>
References: <1273425124-6750-1-git-send-email-pshah.mumbai@gmail.com>
	 <AANLkTiny2Vk3y5DGYWEphQ94_HbgMUEZB1uub08WWs4w@mail.gmail.com>
Date: Mon, 10 May 2010 22:22:16 +0530
Message-ID: <h2w2f9dd5d81005100952pebcd7beby549d1f7762f8e70f@mail.gmail.com>
Subject: Re: [PATCH] Staging: wlags49_h2: fixed C99 comments style issues in 
	wl_profile.c
From: Prashant Shah <pshah.mumbai@gmail.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: gregkh@suse.de, akpm@linux-foundation.org, pe1dnn@amsat.org,
       ext-andriy.shevchenko@nokia.com, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>> -//     } else {
>> -//             this should not be debug time info, it is an enduser data entry error ;?
>> -//             DBG_WARNING(DbgInfo, "%s invalid; will be ignored\n", PARM_NAME_MICROWAVE_ROBUSTNESS);
>> +/*     } else {
>> +               this should not be debug time info, it is an enduser data entry error ;?
>> +               DBG_WARNING(DbgInfo, "%s invalid; will be ignored\n", PARM_NAME_MICROWAVE_ROBUSTNESS); */
> In such case you have lost the internal comments. I think it should look like
> /*
> } else {
> /* ... */

Sent a new patch. I tried the nested comments but gcc wont handle it
correctly (maybe I am wrong here). Please discard the old patch and
use this new one.

-//     } else {
-//             this should not be debug time info, it is an enduser
data entry error ;?
-//             DBG_WARNING(DbgInfo, "%s invalid; will be ignored\n",
PARM_NAME_MICROWAVE_ROBUSTNESS);
+       /* } else { */
+               /* this should not be debug time info, it is an
enduser data entry error ;? */
+               /* DBG_WARNING(DbgInfo, "%s invalid; will be
ignored\n", PARM_NAME_MICROWAVE_ROBUSTNESS); */
