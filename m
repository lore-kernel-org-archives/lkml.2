Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931Ab2IYPwo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 11:52:44 -0400
Received: from mail.x86-64.org ([217.9.48.20]:41635 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753230Ab2IYPwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 11:52:43 -0400
Date: Tue, 25 Sep 2012 17:52:35 +0200
From: Borislav Petkov <bp@amd64.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: specifying raw perf events
Message-ID: <20120925155235.GA6982@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm trying to use raw events and to read how exactly they're specified.
Here's what do:

$ perf list -h

...
  rNNN                                               [Raw hardware event descriptor]
  cpu/t1=v1[,t2=v2,t3 ...]/modifier                  [Raw hardware event descriptor]
   (see 'perf list --help' on how to encode it)
...

$ perf list --help
$

No help. :-(

$ perf --version
perf version 3.6.rc7.1723.g226ea0

That's latest Linus + tip/auto-latest.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
