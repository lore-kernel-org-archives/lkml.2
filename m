Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab1DCUcM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 16:32:12 -0400
Received: from www17.your-server.de ([213.133.104.17]:36323 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410Ab1DCUcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 16:32:11 -0400
X-Greylist: delayed 1578 seconds by postgrey-1.27 at vger.kernel.org; Sun, 03 Apr 2011 16:32:11 EDT
Subject: 2.6.38.2 - perf - unused-but-set-variable
From: Thomas Meyer <thomas@m3y3r.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        a.p.zijlstra@chello.nl
Date: Sun, 03 Apr 2011 22:05:46 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 2.91.92 (2.91.92-2.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1301861150.3763.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

$ make
    CC bench/sched-pipe.o
bench/sched-pipe.c: In function 'bench_sched_pipe':
bench/sched-pipe.c:58:6: error: variable 'ret' set but not used [-Werror=unused-but-set-variable]
cc1: all warnings being treated as errors

make: *** [bench/sched-pipe.o] Error 1

gcc version 4.6.0 20110331 (Red Hat 4.6.0-2) (GCC)



