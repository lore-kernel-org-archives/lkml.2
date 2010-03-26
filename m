Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454Ab0CZBhU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 21:37:20 -0400
Received: from web37904.mail.mud.yahoo.com ([209.191.91.166]:22764 "HELO
	web37904.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752845Ab0CZBhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 21:37:18 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Mar 2010 21:37:18 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type;
  b=qAhRk1VzyoH6eqSRoxKuh5B4eLfEtF5tUbRmM92W9pn/TMP6+BqeCiARrYC35mJvcM8WHzf9JGTPPcr49+oD7Kbd7LHC5FE+hdOQn41X+sjh83yEHXcBH4bBFb5HRxxettMi3dSIxHKa3WqZDAauDNEoWaPPwb7sCRTUeshk2EQ=;
Message-ID: <16733.35890.qm@web37904.mail.mud.yahoo.com>
X-YMail-OSG: d.bZhbEVM1kjdiH1ApMWDZfHwYGs9Pgbdw6T5bUltN4Fzgy
 0gW_gadnKrLtH40vQ8c8Kma9wFNKwU76F0JXvu83ozg2blN.xhWcBTkmJavJ
 .m1R6UuQAJNDG3DIgcsi00ztce7wdCgo30NCl3eE6fMXv.tFU9Fb4_9eqaU0
 ZChmKcgdYJ7D2vAIe8bHIsSezh2RHWU9_Z3EOXPA6oAc0qGmCeePoXry6IX4
 ftzXE1DWiHqruEI9lcbMiZ6D72w94JnxMUg7cYRazHwovag9WXK_aw3CxjAR
 h3tXn_CmKXeF_Lc0bfmJDlW9fyoLg
X-Mailer: YahooMailClassic/10.0.8 YahooMailWebService/0.8.100.260964
Date: Thu, 25 Mar 2010 18:30:36 -0700 (PDT)
From: Gary Yang <garyyang6@yahoo.com>
Subject: How to insert splint info Makefile? Any idea?
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am working on linux-2.6.25. I would like to use splint. At one of the source directory, I typed "splint *.c". I got "Cannot find include file", "Cannot continue". I understand that I need to run splint inside the Makefile so that it will find the correct include files. However, how to insert splint info Makefile? Any idea?


splint *.c
Splint 3.1.2 --- 24 Mar 2010

cache.c:7:25: Cannot find include file asm/pgtable.h on search path:
                 /usr/include;/usr/local/include
  Preprocessing error. (Use -preproc to inhibit warning)
cache.c:42:27: #error Unknown cache type.
Preprocessing error for file: /projects/svdc/P4wsIPCSW/buildsw_canyonlands/linux
                  /arch/m32r/mm/cache.c
*** Cannot continue.


Thanks,


Gary






      
