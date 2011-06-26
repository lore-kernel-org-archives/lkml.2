Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561Ab1FZWHI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 18:07:08 -0400
Received: from mx3.utsp.utwente.nl ([130.89.2.14]:21321 "EHLO mx.utwente.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755478Ab1FZWGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 18:06:17 -0400
Date: Mon, 27 Jun 2011 00:05:44 +0200 (CEST)
From: Martijn Uffing <mp3project@sarijopen.student.utwente.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Jeff Layton <jlayton@redhat.com>
Subject: Re: [Bug #37542] [OOPS] 3.0-rc1 cifs
In-Reply-To: <XWjMN7gBoXK.A.hZD.lZ6BOB@chimera>
Message-ID: <Pine.LNX.4.64.1106262355030.6287@sarijopen.student.utwente.nl>
References: <VDRaLpg_NZ.A.tnC.JZ6BOB@chimera> <XWjMN7gBoXK.A.hZD.lZ6BOB@chimera>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-UTwente-MailScanner-Information: Scanned by MailScanner. Contact icts.servicedesk@utwente.nl for more information.
X-UTwente-MailScanner: Found to be clean
X-UTwente-MailScanner-From: mp3project@sarijopen.student.utwente.nl
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ave

The OOPS/BUG is fixed by 2 patches. Both patches are already included in 
the linus git tree.

A patch for the separate issue to demote the superfluous kernel messages 
from error to debug level is available, but not yet included in linus git.
I will track this patch and ping the author if it isn't included in one of 
the final rc's.

As far as I am concerned, this bug can be removed from the regression 
list.

Martijn

-----------------------------------------
Ceterum censeo Carthaginem esse delendam

When it comes to procrastination, casting the first stone is definitely on
my TO DO list.



On Sun, 26 Jun 2011, Rafael J. Wysocki wrote:

> This message has been generated automatically as a part of a summary report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.39.  Please verify if it still should be listed and let the tracking team
> know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=37542
> Subject		: [OOPS] 3.0-rc1 cifs
> Submitter	: Martijn Uffing <mp3project@sarijopen.student.utwente.nl>
> Date		: 2011-06-09 20:15 (18 days old)
> Message-ID	: <Pine.LNX.4.64.1106092211500.19687@sarijopen.student.utwente.nl>
> References	: http://marc.info/?l=linux-kernel&m=130765235926144&w=2
> Handled-By	: Jeff Layton <jlayton@redhat.com>
> Patch		: https://bugzilla.kernel.org/attachment.cgi?id=63202
>
>
>
