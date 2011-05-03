Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab1ECSvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 14:51:39 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60193 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258Ab1ECSvi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 14:51:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NpHlNB+sdzgXGdHcV/G05QKJs6h3py+iNVxFiV+WCIncdnfLMO+LDiks+a4q30PoZU
         Hb8VHJ7cc/NbYXwp9uPuNCmbUzh8AE8gX4ibtvfFp63numIQ0i0V0GgrvRyqj7dpp71Q
         akbHBNqsWxLcU/4eW0mXNjRXpiMA5vxPGl3lU=
MIME-Version: 1.0
In-Reply-To: <20110503130123.GA23498@redhat.com>
References: <BANLkTikAun3_-WyKE0RJiXei=QGXQ1g+JQ@mail.gmail.com>
	<20110503130123.GA23498@redhat.com>
Date: Tue, 3 May 2011 20:51:37 +0200
Message-ID: <BANLkTi=oqFwfm2q12FyVR0xSOKABG-PtPA@mail.gmail.com>
Subject: Re: Hard LOCKUP, maybe acpi related (present in 2.6.32 to 2.6.37,
 fixed in 2.6.38)
From: =?ISO-8859-1?Q?Sebastian_F=E4rber?= <faerber@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> It looks like you are using the old nmi watchdog which may have given you
> false positives.  Can you turn on the new nmi watchdog (for 2.6.36 or
> later)?
>
> CONFIG_LOCKUP_DETECTOR=y
> CONFIG_HARDLOCKUP_DETECTOR=y
>
> and see if that gives a more meaningful backtrace?

I've recompiled 2.6.36.4 and 2.6.37.6 with both options enabled and
removed "nmi_watchdog=1" from the
kernel cmdline.
I'll get back to you if i get another lockup, could take a few days
unfortunatly.
Thanks for your help!

Regards,
Sebastian
