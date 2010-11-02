Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab0KBSDQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 14:03:16 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47485 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653Ab0KBSDH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 14:03:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=aTntAqnmXWao9D6qwkR8D5ev9iEkolHU22QjVlDSeacntl+AVjGWGVq8+fbw/eUHnI
         wCnSd6weMYyTl5+LzSvPdyk4L1N4fFJ2AUd6orrYpz5dhDHElMpBhE4rP+NWOVVhxfxd
         MsK5/D/ZdeP1hmKf4CIK3Kd8Gv2YJ7Ws0PlWo=
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.37 rc1 doesn't suspend to ram
Date: Tue, 2 Nov 2010 19:02:59 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc1-00004-geb8abb9-dirty; KDE/4.5.3; x86_64; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, suspend-devel@lists.sourceforge.net
References: <201011011955.39485.a.miskiewicz@gmail.com> <201011011959.08933.a.miskiewicz@gmail.com> <201011021413.50822.rjw@sisk.pl>
In-Reply-To: <201011021413.50822.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201011021903.00320.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 of November 2010, Rafael J. Wysocki wrote:
> On Monday, November 01, 2010, Arkadiusz Miskiewicz wrote:
> > On Monday 01 of November 2010, Arkadiusz Miskiewicz wrote:
> > > Hi,
> > > 
|
> > [ 2012.149491] PM: Syncing filesystems ... done.
> > [ 2013.092294] Freezing user space processes ... (elapsed 0.01 seconds)
> > done. [ 2013.108138] Freezing remaining freezable tasks ... (elapsed
> > 0.01 seconds) done. [ 2013.124226] Suspending console(s) (use
> > no_console_suspend to debug) [ 2013.144256] btusb_intr_complete: hci0
> > urb ffff8800b446dcc0 failed to resubmit (1) [ 2013.145254]
> > btusb_bulk_complete: hci0 urb ffff8800b446d180 failed to resubmit (1) [
> > 2013.146255] btusb_bulk_complete: hci0 urb ffff8800b446d3c0 failed to
> > resubmit (1) [ 2013.297335] sd 0:0:0:0: [sda] Synchronizing SCSI cache

> Can you try the patch at http://lkml.org/lkml/2010/10/21/456, please?

This patch fixes things, thanks!

> Rafael

-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
