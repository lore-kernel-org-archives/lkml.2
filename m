Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751406Ab1EUFVR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 01:21:17 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50273 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab1EUFVL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 01:21:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type
         :content-transfer-encoding;
        b=bQDQpD0NgHz7OfDnaDFw79gjbTGiBIJ3cprXqq767uCtomQhwkL1iL6ywQSDhowgGq
         ooNX5WrUS+6M5KhpiUX805Jl4ZZjCSJdLi7gdd6/xLY0hqRG5g1mda56WsC/10JflTmH
         cUmUCiKzd0LoTz4mQ5/Q/2eToxj8tfeLbMdzU=
MIME-Version: 1.0
From: Jim Cromie <jim.cromie@gmail.com>
Date: Fri, 20 May 2011 23:20:40 -0600
Message-ID: <BANLkTim=7dsHXtpP0Cpeg56dmNxx4_aG9Q@mail.gmail.com>
Subject: MAINTAINERS out of date
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

anyone know where    anil_ravindranath@pmc-sierra.com  is ?


---------- Forwarded message ----------
From: Mail Delivery Subsystem <mailer-daemon@googlemail.com>
Date: Fri, May 20, 2011 at 10:21 PM
Subject: Delivery Status Notification (Failure)
To: jim.cromie@gmail.com


Delivery to the following recipient failed permanently:

    anil_ravindranath@pmc-sierra.com

Technical details of permanent failure:
Google tried to deliver your message, but it was rejected by the
recipient domain. We recommend contacting the other email provider for
further information about the cause of this error. The error that the
other server returned was: 550 550 5.1.1
<anil_ravindranath@pmc-sierra.com>: Recipient address rejected: User
unknown in local recipient table (state 14).

----- Original message -----

Received: by 10.142.215.18 with SMTP id n18mr81103wfg.332.1305951690117; Fri,
 20 May 2011 21:21:30 -0700 (PDT)
MIME-Version: 1.0
Received: by 10.143.59.18 with HTTP; Fri, 20 May 2011 21:21:00 -0700 (PDT)
In-Reply-To: <4DD68BE0.6030003@panasas.com>
References: <1305840792-25877-1-git-send-email-jim.cromie@gmail.com>
 <1305840792-25877-9-git-send-email-jim.cromie@gmail.com>
<4DD68BE0.6030003@panasas.com>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Fri, 20 May 2011 22:21:00 -0600
Message-ID: <BANLkTi=6qWpUX6wMi5egRhi+qigaGPgnFQ@mail.gmail.com>
Subject: Re: [PATCH 08/23] use register_chrdev_ids in drivers/scsi/
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
       Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org,
       Benny Halevy <bhalevy@panasas.com>, osd-dev@open-osd.org,
       Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Fri, May 20, 2011 at 9:42 AM, Boaz Harrosh <bharrosh@panasas.com> wrote:
> On 05/20/2011 12:33 AM, Jim Cromie wrote:
>> cc: Doug Gilbert <dgilbert@interlog.com>
>> cc: linux-scsi@vger.kernel.org
>> cc: Benny Halevy <bhalevy@panasas.com>
>> cc: Boaz Harrosh <bharrosh@panasas.com>
>> cc: osd-dev@open-osd.org
>> cc: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
>> cc: linux-scsi@vger.kernel.org
>> Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
>> ---
>>  drivers/scsi/osd/osd_uld.c |    6 +++---
>>  drivers/scsi/pmcraid.c     |    3 +--
>>  drivers/scsi/sg.c          |    6 +++---
>>  drivers/scsi/st.c          |    7 +++----
>>  4 files changed, 10 insertions(+), 12 deletions(-)
>
> Do you have a git tree with all these that I can pull
> and test?
>

I do, its at git://github.com/jimc/linux-2.6.git  chrdev-pub1 branch

For you, I think there are 3 patches of interest
1 - adds new call, deprecates old.
if you build with this applied and CONFIG_ENABLE_WARN_DEPRECATED=y
you should get a deprecated warning
2 - reimplements alloc_chardev_region() with register_chardev_ids()
your driver may be using register_chardev_region(), if so this is uninteresting.
3 - patch that adapts your scsi parts.

> Thanks
> Boaz
>

no, thank you
Jim Cromie
