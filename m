Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258Ab0C3HMk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 03:12:40 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:46738 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab0C3HMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 03:12:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=whdQblMY85Qay9JUl+Gl/ZUI7ox2yMGfNznV92SszICAQLI+57sqgdCDBEj9tUWTvg
         6jxFckhdrMe30HypOgxpm2u6EhmjbW5a4ArC7AACMSzYu0N/yaC76saFCJRArNr826+x
         C4XpJj/FFw6DU1+pppzOG9HArjhl2nXWRvzbk=
MIME-Version: 1.0
Date: Tue, 30 Mar 2010 12:42:36 +0530
Message-ID: <241b8f7b1003300012j6485f4d3hef0e5ae9c1155791@mail.gmail.com>
Subject: Setting up KGDB environment on MIPS Processor.
From: Prabhu Chawandi <prabhu.chavandi@gmail.com>
To: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mips@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

 I am trying to settup the  KGDB settup, for my STB  BRCM board.

I have 3 UARTS -0,1,2 --

Boot the kdb enabled kernel.. but not able to get the  --- gdb wait message --

I am setting up an environment for kernel debugging on my MIPS based
processor. In whatever document I read there I could get deatails of
debugging a PC but not the embedded board.
Still i tried to start session which was unsuccessful.

Configs enabled: CONFIG_KGDB=y
CONFIG_KGDB_CONSOLE=y
CONFIG_KGDB_8250_NOMODULE=y
CONFIG_SYS_SUPPORTS_KGDB=y

and I can see the change in size of the vmlinux.

while booting I have given command parameters :

boot -z -elf <vmlinuz path> "kgdb8250=1 115200" kgdbwait ------

but my kernel is not waiting for remote gdb to wait for the connection.

Am I missing anything ?

Help me to set it up ...

I had put pritnks I am getting

 KGDB :  kgdb_late_entry ..
 KGDB: kgdb_arch_init .....
KDGB: kgdb_internal_init ....
 KGDB: Setting kgdb_initialized ..

but normally going to login prompt ...

when  I press ^C -- Breakpoint is catched -- then everyting come to halt ..

Thanks
prabhu
