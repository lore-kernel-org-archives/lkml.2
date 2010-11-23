Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab0KWIHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 03:07:42 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:49372 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab0KWIHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 03:07:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=UXUA7bRk+OCyArhRw493qWk/oQOL8xMSNmSL4Z4a6ZG750WW9Et0i/jh5xrdp+NvS+
         HboPO/mmgBxiZCKUkSCo4oJ1P93CBVqutHq6wxnlL3jR5twADHGn6c2aWYD0APJa4Nkb
         fKo9tLWCA6g1KDLr+7qjy8GCrROGBNdpxNLI8=
MIME-Version: 1.0
Date: Tue, 23 Nov 2010 16:07:39 +0800
Message-ID: <AANLkTik4QDCD0rAZ=04Ph23ApZ822BBoOWEiPEp7GBNr@mail.gmail.com>
Subject: 'perf test' failed on ARM
From: Ming Lei <tom.leiming@gmail.com>
To: Ian Munsie <imunsie@au1.ibm.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Tom Zanussi <tzanussi@gmail.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

'perf test' is failed on linux 2.6.37-rc2/rc3, follows log info:

root@beagleboard:/mnt/omap/linux-2.6-omap/tools/perf# ./perf test -v 3
 1: vmlinux symtab matches kallsyms:
--- start ---
dso__find_symbol_by_name ---- end ----
vmlinux symtab matches kallsyms: FAILED!

Any suggestions?

-- 
Lei Ming
