Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab0DUCCt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 22:02:49 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45814 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714Ab0DUCCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 22:02:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:subject:to:cc:in-reply-to:references;
        b=m1fXcaeiceS9YUPqrhuJdsBmLxVrWFMCuxHLaAckI2fz7z6MFICCWIXEDdiwznv2de
         GlD9iKmdTIX5F3LiN5rpRn3rjsy9JRMOwYzxPPNYYauPMWb7mCozwFEn61WV0Uhpa6uz
         IsRxImn6bvmF2vnE4zTmI9WyN+HumfPEe3Jjg=
Message-ID: <4bce5cc3.966bdc0a.2ef7.fffff5de@mx.google.com>
Date: Tue, 20 Apr 2010 19:02:43 -0700 (PDT)
From: Ben Gamari <bgamari.foss@gmail.com>
Subject: Re: 2.6.34-rc5: Reported regressions from 2.6.33
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>
In-Reply-To: <deuQKFRcc0B.A.3EG.BRSzLB@tosh>
References: <deuQKFRcc0B.A.3EG.BRSzLB@tosh>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Apr 2010 05:15:57 +0200 (CEST), "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> This message contains a list of some regressions from 2.6.33,
> for which there are no fixes in the mainline known to the tracking team.
> If any of them have been fixed already, please let us know.
> 
> If you know of any other unresolved regressions from 2.6.33, please let us
> know either and we'll add them to the list.  Also, please let us know
> if any of the entries below are invalid.
> 

I have recently reported this suspend regression on my Dell laptop hardware.

References: http://lkml.org/lkml/2010/4/18/20
Bug-report: https://bugzilla.kernel.org/show_bug.cgi?id=15820

Thanks,

- Ben
