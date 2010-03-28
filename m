Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab0C1QLH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 12:11:07 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:63733 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726Ab0C1QLF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 12:11:05 -0400
MIME-Version: 1.0
Message-ID: <3fa4ae08-42db-4ee0-b86f-567997c35dd4@default>
Date: Sun, 28 Mar 2010 09:09:17 -0700 (PDT)
From: Randy Dunlap <randy.dunlap@oracle.com>
To: <eduard.munteanu@linux360.ro>
Cc: <fweisbec@gmail.com>, <mingo@elte.hu>, <linux-kernel@vger.kernel.org>,
       <lizf@cn.fujitsu.com>, <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] Remove Documentation/trace/kmemtrace.txt
X-Mailer: Zimbra on Oracle Beehive
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B0206.4BAF7F7A.0130:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.

---
~Randy


----- Original Message -----
From: eduard.munteanu@linux360.ro
To: mingo@elte.hu
Cc: randy.dunlap@oracle.com, lizf@cn.fujitsu.com, fweisbec@gmail.com, penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org, eduard.munteanu@linux360.ro
Sent: Sunday, March 28, 2010 1:27:31 AM GMT -08:00 US/Canada Pacific
Subject: [PATCH] Remove Documentation/trace/kmemtrace.txt

The current implementation of kmemtrace has been based on ftrace for a
while. Documentation/trace/kmemtrace.txt concerns the old, relay-based
implementation, so it's outdated. This removes it to avoid confusion.

Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
---
 Documentation/trace/kmemtrace.txt |  126 -------------------------------------
 1 files changed, 0 insertions(+), 126 deletions(-)
 delete mode 100644 Documentation/trace/kmemtrace.txt
