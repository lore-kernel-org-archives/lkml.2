Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab0E2QrA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 12:47:00 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:45342 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab0E2Qq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 12:46:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:cc
         :content-type;
        b=p7XoD+TQczVp3wZ28QpsqlDDWYiBvvHCsVsofRZfK8bryDgs+tfi/WpPjM/7Q5hpyw
         2IqqDIaqiiMFM0+ijNcgTtzIzrxTJR2B+zvkb3LCkfYUCZ+UKNzORbSzp8+imzDF4LxC
         5YUOZj1FIxug2AXskNo6UgBeyNMUQ4apRVyxc=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Sat, 29 May 2010 18:46:54 +0200
Message-ID: <AANLkTilvD_UjUCxN3iag1kp-D8R25P_Gh_cAjwB70BCD@mail.gmail.com>
Subject: Re: [git head f4b87dee9] BUG: using smp_processor_id() in preemptible 
	(VFS-related)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
       dmonakhov@openvz.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regression should be fixed by (see pull-request in [1]):

commit f32764bd2bbb6ea003c158b1d276b4dc9f900348
"quota: Convert quota statistics to generic percpu_counter"

The patch is still pending in linux-fs-2.6/for_linus GIT tree and it's
not accepted in upstream, yet.

- Sedat -

[1] http://lkml.org/lkml/2010/5/27/499
[2] http://git.kernel.org/?p=linux/kernel/git/jack/linux-fs-2.6.git;a=commit;h=f32764bd2bbb6ea003c158b1d276b4dc9f900348
