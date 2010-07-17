Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728Ab0GQDb0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 23:31:26 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:47381 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471Ab0GQDbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 23:31:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=MZ3dU9E2qOK+DTkwuIQTx4adCeg1Ko+miwq/p2vJKvOk4TvB/ujZJebUdNQdm0qAwL
         cf8/he3ai7R/vqTFiN7DLxRNJyIu2dzTtlto+12qknlIJ93Ec1P/yT+A/GpaqDQ6BECB
         hTC56gACP/Ymp9Dkfvy+2lbDrunvslxNCFjCc=
MIME-Version: 1.0
Date: Fri, 16 Jul 2010 21:31:23 -0600
Message-ID: <AANLkTikE1NUUvCSmsci110TH7hT0zHIzlfS03hvhDfPN@mail.gmail.com>
Subject: [ANNOUNCE] Merkey's Linux Kernel Debugger (MDB) 07-16-2010 UPDATES 
	kernels 2.6.28 through 2.6.34.1 (release 3)
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found a few more items.  This pass of x86_64 is pretty much complete
and fully tested on all these kernels.  releases will follow the
stable version numbers.  Next releases on ARM.

For kernels:

linux 2.6.28.10
linux 2.6.29.6
linux 2.6.30.10
linux 2.6.31.14
linux 2.6.32.16
linux 2.6.33.6
linux 2.6.34.1

CURRENT

http://merkeydebugger.googlecode.com/files/mdb-2.6.34.1-x86_64-07-16-2010.patch
http://merkeydebugger.googlecode.com/files/mdb-2.6.33.6-x86_64-07-16-2010.patch
http://merkeydebugger.googlecode.com/files/mdb-2.6.32.16-x86_64-07-16-2010.patch
http://merkeydebugger.googlecode.com/files/mdb-2.6.31.14-x86_64-07-16-2010.patch
http://merkeydebugger.googlecode.com/files/mdb-2.6.30.10-x86_64-07-16-2010.patch
http://merkeydebugger.googlecode.com/files/mdb-2.6.29.6-x86_64-07-16-2010.patch
http://merkeydebugger.googlecode.com/files/mdb-2.6.28.10-x86_64-07-16-2010.patch

REPOSITORIES

http://code.google.com/p/merkeydebugger/
http://sourceforge.net/projects/merkeydebugger/


FIXES:
- limit bracketing to scalar register expressions only in disassembler deref
- fix genapic unresolved error in x86_84 build for 2.6.28.10 and 2.6.29.6


Jeff Merkey
