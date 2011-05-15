Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586Ab1EOI2c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 04:28:32 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51596 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607Ab1EOI22 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 04:28:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Nmzc0foxFnCvySGesGLySMDnZXvj8NsKM8J+HzTJrSUpUE/d0UwYaStUBxIvZvxb3H
         vSr19kUEJkpQ2+uicfcZvdqVbvJ56mkCsFiByeEKPMSNWQNj8Wv41xJSvnKm4ND3novB
         qTuapDcnJ7F/qE+IFn7hvVxCUk4mNM94Wy8uA=
MIME-Version: 1.0
In-Reply-To: <BANLkTiktnQyEnNiQdTr_p=PG66rzVkr9ig@mail.gmail.com>
References: <1302960373-5309-1-git-send-email-abogani@kernel.org>
	<BANLkTi=y60Jt3-OMzbxQJzGkvzCzNJfJtA@mail.gmail.com>
	<BANLkTimfFEv+vZ8dYvhG0oj2Q4g+KnG4aA@mail.gmail.com>
	<BANLkTinDiGCaKPtS+ZpKf2swJpParJ4eew@mail.gmail.com>
	<BANLkTi=JXq+V783amiJB-qLX=7PaeH-83w@mail.gmail.com>
	<BANLkTi=OXuR4iJFqUEa4pA=yO0aXaqEzyA@mail.gmail.com>
	<BANLkTikFSN-DkkPNPtv1VigCg08YoB_q2g@mail.gmail.com>
	<BANLkTi=fhsSP069WMNPN8BA=E1=1TZ6Zmw@mail.gmail.com>
	<BANLkTikyR7ByAgxtbz-gOHspLMFo4a+vaQ@mail.gmail.com>
	<BANLkTinQx+8T3Hv0T5yPEAtxtU87CcOJVw@mail.gmail.com>
	<BANLkTiktnQyEnNiQdTr_p=PG66rzVkr9ig@mail.gmail.com>
Date: Sun, 15 May 2011 10:28:25 +0200
X-Google-Sender-Auth: fAJMJ_ub36atCoQNI5S9d1yTPsw
Message-ID: <BANLkTinr5xw8wDrZ6P1d5BYLRMmj-i3w4g@mail.gmail.com>
Subject: Re: [PATCH 0/4] Speed up the symbols' resolution process V4
From: Alessio Igor Bogani <abogani@kernel.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Tim Abbott <tabbott@ksplice.com>,
        Anders Kaseorg <andersk@ksplice.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Tim Bird <tim.bird@am.sony.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Mr. Frysinger,

2011/5/14 Mike Frysinger <vapier.adi@gmail.com>:
> On Fri, May 13, 2011 at 03:01, Alessio Igor Bogani wrote:
>> I changed the "__" in "+". Could you test this, please?
>> http://git.kernel.org/?p=linux/kernel/git/abogani/linux-2.6.git;a=shortlog;h=refs/heads/ksym-sorted-v6
>> Thanks a lot!
>
> seems to build & boot ok for me.  cheers.
> -mike

Thank you very much!

Ciao,
Alessio
