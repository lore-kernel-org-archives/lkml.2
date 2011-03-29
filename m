Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab1C2Hvf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 03:51:35 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:47011 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab1C2Hve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 03:51:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=oobD5mOWCpMVdwsJihVzIZ2RoCguDlQEsS1Xh0TzTf/oHaV2z2ISpruqyBX92bFbbX
         A29FPnPWHp/GZ8uEMVZa7MkBzpRcITgGDJh4MxEpUL099m9QmoERr+loJMkcAHO3SASA
         TLJzffXSvDkEXXLqp+QGOQNOEAVo8IHz2Wd3g=
MIME-Version: 1.0
In-Reply-To: <20110329073632.GB10163@osiris.boeblingen.de.ibm.com>
References: <1300978173-9983-1-git-send-email-dbaluta@ixiacom.com>
	<20110329073632.GB10163@osiris.boeblingen.de.ibm.com>
Date: Tue, 29 Mar 2011 10:51:33 +0300
X-Google-Sender-Auth: c6v8vV439_U2bS45C3HrIUMX1sc
Message-ID: <AANLkTi=Kr5DQrZW+d=u-fyYcDNQogBj=TFr1_25+Z4Uw@mail.gmail.com>
Subject: Re: [PATCH] kmemleak: update documentation
From: Daniel Baluta <dbaluta@ixiacom.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>, rdunlap@xenotime.net
Cc: catalin.marinas@arm.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +Kmemleak is supported on x86, arm, powerpc, sparc, sh, microblaze and tile.
>
> You missed s390.

You are right.

Randy, should I send a v2 of this patch, or is it already applied?
Another option would be to send a separate patch adding s390,
on top of my previous patch.

thanks,
Daniel.
