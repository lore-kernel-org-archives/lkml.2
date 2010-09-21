Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757789Ab0IURYI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 13:24:08 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:53603 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748Ab0IURYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 13:24:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=aRILYd9T8bkzxI+33/SOG5Gyug9ilaw/kJGxP2tq7Pil4OKFGZwys7+ijgVHdE8MS1
         X3dr0IY7QCo3AHi0vLtV/GKnUbmtt0yRyIt5IzM4a+hDgIJ4J9jBhhq3Zo6orf3QBDGg
         Vrc4/qcgQaeOEq1ws8+tUstlOrGdVvtsMRkWg=
MIME-Version: 1.0
Date: Tue, 21 Sep 2010 10:23:57 -0700
Message-ID: <AANLkTimOVY+iOOMKhwFfX5Wcw1y_PcvoCCfEcjoPmj3J@mail.gmail.com>
Subject: [2.6.35-rc5] hp-wmi patch missed .35 merge window, requesting
 addition to next rc
From: Josh Hill <joshua.hill@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: torvalds@osdl.org, alan@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

please cc as i'm unsubscribed
as reported in this bug: https://bugzilla.kernel.org/show_bug.cgi?id=15344
and the patch: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=751ae808f6b29803228609f51aa1ae057f5c576e

the backlight on this laptop goes down one level whenever
/proc/acpi/ac_adapter/*/status is read.
i've been told the patch missed the .35 merge window, and is going to
be in .36, but ubuntu is
going to release 10.10 soon with .35 in it, and if this patch doesn't
make it into .35 my laptop
will be doing this for its (10.10) entire lifetime. i didn't know who
to really contact and request this sort
of thing so i'm doing it here.

thanks,
  josh
