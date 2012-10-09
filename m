Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317Ab2JIRHv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 13:07:51 -0400
Received: from mail.x86-64.org ([217.9.48.20]:39274 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752303Ab2JIRHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 13:07:49 -0400
Date: Tue, 9 Oct 2012 19:07:34 +0200
From: Borislav Petkov <bp@amd64.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: perf build error (linux/rbtree_augmented.h)
Message-ID: <20121009170734.GB32508@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is this an already known issue (building perf on latest linus):

$ make tools/perf_install

...

../../lib/rbtree.c:24:36: fatal error: linux/rbtree_augmented.h: No such file or directory
compilation terminated.
make[2]: *** [util/rbtree.o] Error 1
make[1]: *** [perf_install] Error 2
make: *** [tools/perf_install] Error 2

?

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
