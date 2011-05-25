Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002Ab1EYPUe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 11:20:34 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:43753 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757794Ab1EYPUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 11:20:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type;
        b=TjOGF26XPZ1rqg0B7SUCHb8XWu/uHD5nZifGj3vm7BbCzy8jqspuXXpm0z96oNnetz
         0GMX0LM/hruVhGTAOuGQIRm4SDHq11OQ23s/n7rSr8RXZ7Xp9lTc3eX2VjMRBWkmLviD
         0zGxxUQEzp2/ld4CWbUVyfOmbTPrqRpla3NJY=
MIME-Version: 1.0
Date: Wed, 25 May 2011 17:20:29 +0200
X-Google-Sender-Auth: 3y7SZAeltarjS_PcsW-ci5FcomY
Message-ID: <BANLkTin+PPqSSqwHgo0kE0T2m3k9EKasnA@mail.gmail.com>
Subject: merge of v2.6.33.14 with tip/rt/2.6.33
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: RT <linux-rt-users@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Carsten Emde <Carsten.Emde@osadl.org>, stable@kernel.org,
        Clark Williams <williams@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas

I'm still doing some testing but I have merged v2.6.33.14 with my own
v2.6.33.13-rt31 which ultimately comes from tip/rt/2.6.33
I see that Carsten has also already done the same thing.

This can be fetched from

git://git.kernel.org/pub/scm/linux/kernel/git/jkacur/jk-2.6.git    rt/2.6.33

What follows is the commit-log

commit aac9a6b18a38b03f0d61a1b64c0a8762b6ad6a5f
Merge: cbbe989 0413500
Author: John Kacur <jkacur@redhat.com>
Date:   Wed May 25 15:35:54 2011 +0200

    Merge commit 'v2.6.33.14' into rt/2.6.33

    * commit 'v2.6.33.14': (23 commits)
      Linux 2.6.33.14
      vmxnet3: Fix inconsistent LRO state after initialization
      megaraid_sas: Sanity check user supplied length before passing it to dma_a
      x86, mce, AMD: Fix leaving freed data in a list
      x86, apic: Fix spurious error interrupts triggering on all non-boot APs
      tick: Clear broadcast active bit when switching to oneshot
      clocksource: Install completely before selecting
      x86, AMD: Fix ARAT feature setting again
      Revert "x86, AMD: Fix APIC timer erratum 400 affecting K8 Rev.A-E processo
      cifs: add fallback in is_path_accessible for old servers
      fixes for using make 3.82
      zorro8390: Fix regression caused during net_device_ops conversion
      libertas: fix cmdpendingq locking
      hydra: Fix regression caused during net_device_ops conversion
      ne-h8300: Fix regression caused during net_device_ops conversion
      NET: slip, fix ldisc->open retval
      ehea: fix wrongly reported speed and port
      CIFS: Fix memory over bound bug in cifs_parse_mount_options
      dccp: handle invalid feature options length
      ptrace: Prepare to fix racy accesses on task breakpoints
      ...

    Conflicts:
        Makefile
        include/linux/sched.h

    Signed-off-by: John Kacur <jkacur@redhat.com>
