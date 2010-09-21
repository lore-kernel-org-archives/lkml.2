Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751393Ab0IUEFT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 00:05:19 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44593 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735Ab0IUEFR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 00:05:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=m/bZalkr0stF+Z3Q3jeKoVShflqp03QwXjUWDfzXT56W3lYA31Nof4q0Wm2v0jTuwt
         RsteszeJHKboGLSQU4/mvhuZ4hPDldJpqraZMo8o8xIiFrTjRHqDtxfpbj1k9noZKPMj
         QDbDqZ6JXd2Bm6H6bxwvsXXJXERTBXY1bOsqw=
MIME-Version: 1.0
In-Reply-To: <AANLkTinLR0Js0ueVOGEkbs27d4FEH14c=1wuhUqPsiHx@mail.gmail.com>
References: <1fwtoy8sG5H.A.veG.9D7lMB@chimera>
	<AANLkTinLR0Js0ueVOGEkbs27d4FEH14c=1wuhUqPsiHx@mail.gmail.com>
Date: Tue, 21 Sep 2010 00:05:15 -0400
Message-ID: <AANLkTikNm90F6rpi7u=XUOG-Ga6F0+h=bFwkC-sKaO4j@mail.gmail.com>
Subject: Re: 2.6.36-rc4-git5: Reported regressions from 2.6.35
From: Alex Deucher <alexdeucher@gmail.com>
To: sedat.dilek@gmail.com
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        Florian Mickler <florian@mickler.org>, harn-solo@gmx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 20, 2010 at 3:19 PM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
> Hi Rafael,
>
> can you please add the following, Thanks in advance.
>> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=18872
>> Subject         : Radeon KMS r100 and STR problems
>> Submitter       : Richard Mittendorfer <delist@gmx.net>
>> Date            : 2010-09-17 18:26 (4 days old)
>> Message-ID      : <20100917202647.aa4b6300.delist@gmx.net>
>> References      : http://marc.info/?l=linux-kernel&m=128474802809779&w=2
>
> On Mon, Sep 20, 2010 at 8:47 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> This message contains a list of some regressions from 2.6.35,
>> for which there are no fixes in the mainline known to the tracking team.
>> If any of them have been fixed already, please let us know.
>>
>> If you know of any other unresolved regressions from 2.6.35, please let us
>> know either and we'll add them to the list.  Also, please let us know
>> if any of the entries below are invalid.
>>
>> Each entry from the list will be sent additionally in an automatic reply
>> to this message with CCs to the people involved in reporting and handling
>> the issue.
>>
>>
>> Listed regressions statistics:
>>
>>  Date          Total  Pending  Unresolved
>>  ----------------------------------------
>>  2010-09-20       38       15          15
>>  2010-09-12       28       14          13
>>  2010-08-30       21       16          15
>>
>>
>> Unresolved regressions
>
> Hi Rafael,
>
> can you please add the following Bug, Thanks in advance.
>
> Bug-Entry       : https://bugzilla.kernel.org/show_bug.cgi?id=16140
> Subject         : Suspend To RAM/ Resume broken - Radeon KMS on RV250
> Submitter       : Michael Long <harn-solo@gmx.de>
> Date            : 2010-06-06 09:52
> Message-ID      : ???
> References      : ???
>
> What is with "Regression:       No" in the BR? Change?

This isn't a regression as according to your bug report, s/r has never
worked on your board with kms.  The kms and ums drm components are
completely different drivers even though they are compiled into the
same binary.

Alex

>
> Regards,
> - Sedat -
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
>
