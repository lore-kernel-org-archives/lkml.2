Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972Ab2IHS6g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 14:58:36 -0400
Received: from smtp.nfit.au.dk ([130.225.17.180]:38239 "EHLO nysmtp.nfit.au.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754102Ab2IHS6e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 14:58:34 -0400
X-Greylist: delayed 501 seconds by postgrey-1.27 at vger.kernel.org; Sat, 08 Sep 2012 14:58:34 EDT
From: Soren Sandmann <soren.sandmann@gmail.com>
From: sandmann@cs.au.dk (=?utf-8?Q?S=C3=B8ren?= Sandmann)
To: gnome-announce-list@gnome.org, linux-kernel@vger.kernel.org,
        gnome-performance-list@gnome.org, gnome-devtools-list@gnome.org
Subject: Announce: Sysprof 1.2.0; system-level profiler for Linux
Date: Sat, 08 Sep 2012 20:50:10 +0200
Message-ID: <ye8392sbb8d.fsf@llama07.cs.au.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A new stable release 1.2.0 of the Sysprof system-level sampling profiler
for Linux is now available. News since 1.0:

- User interface improvements
- Improved tracking of time spent in kernel
- Command line version
- Performance improvements
- Now based on perf_event_open system call

Where to get it:

   Download:               http://sysprof.com/sysprof-1.2.0.tar.gz
   Sysprof web site:       http://sysprof.com/
   Anonymous git:          git://git.gnome.org/sysprof  (tag: 1.2.0)
   Sysprof mailing list:
   http://mail.gnome.org/mailman/listinfo/sysprof-list

Please send patches and bug reports to

        sysprof-list@gnome.org


Søren
