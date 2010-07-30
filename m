Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889Ab0G3EgA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 00:36:00 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64461 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab0G3Ef7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 00:35:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=wXVTt9NZjaQ3jVdf7aHAcF4lrB0gBaSBLTI2EvuzFP4XQVKnUBi8UHfPF4CYTRHjbk
         hFwVKTqjSm7ZyJ8CB7WzawwJoMgJk4ZNeiutO+Hzw5u+VpY+O38anWqSmhvz4uMD2Fqw
         WCQood4oIQHzyUDBNFgyp7iXgV90ljXFiYh7k=
MIME-Version: 1.0
Date: Thu, 29 Jul 2010 22:35:57 -0600
Message-ID: <AANLkTimnXJpz-zbJnw6GxN+TrN8g13iTjNF9Weogg-dr@mail.gmail.com>
Subject: [ANNOUNCE] Merkey's Linux Kernel Debugger (MDB) 07-28-2010 UPDATES 
	kernels 2.6.28 through 2.6.34.1
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For kernels:

linux 2.6.28.10
linux 2.6.29.6
linux 2.6.30.10
linux 2.6.31.14
linux 2.6.32.16
linux 2.6.33.6
linux 2.6.34.1

CURRENT
http://merkeydebugger.googlecode.com/files/mdb-2.6.28.10-x86_64-07-28-2010.patch
http://merkeydebugger.googlecode.com/files/mdb-2.6.29.6-x86_64-07-28-2010.patch
http://merkeydebugger.googlecode.com/files/mdb-2.6.30.10-x86_64-07-28-2010.patch
http://merkeydebugger.googlecode.com/files/mdb-2.6.31.14-x86_64-07-28-2010.patch
http://merkeydebugger.googlecode.com/files/mdb-2.6.32.16-x86_64-07-28-2010.patch
http://merkeydebugger.googlecode.com/files/mdb-2.6.33.6-x86_64-07-28-2010.patch
http://merkeydebugger.googlecode.com/files/mdb-2.6.34.1-x86_64-07-28-2010.patch

FIXES:
- fix UP build with CONFIG_SMP conditionals all kernels
- fix warn_slowpath_null messages from WARN_CONSOLE_LOCKED all kernels
- regression test all kernels 2.6.28 through 2.6.34.1

TODO:
- Integrate GDB opcodes library for all Linux architectures
